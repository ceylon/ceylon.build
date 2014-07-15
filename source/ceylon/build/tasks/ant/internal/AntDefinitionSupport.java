package ceylon.build.tasks.ant.internal;

import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.tools.ant.IntrospectionHelper;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.DataType;

import ceylon.collection.LinkedList;

public class AntDefinitionSupport {
    
    private Project project;
    private String antName;
    private Class<Object> elementType;
    private Class<Object> effectiveElementType;
    private IntrospectionHelper introspectionHelper;
    private boolean definitelyType;
    
    public AntDefinitionSupport(Project project, String antName, Class<Object> elementType, Class<Object> effectiveElementType, IntrospectionHelper introspectionHelper, boolean definitelyType) {
        this.project = project;
        this.antName = antName;
        this.elementType = elementType;
        this.effectiveElementType = effectiveElementType;
        this.introspectionHelper = introspectionHelper;
        this.definitelyType = definitelyType;
    }
    
    public void fillAttributeList(LinkedList<AntAttributeDefinitionSupport> result) {
        Map<String, Class<?>> attributeMap = introspectionHelper.getAttributeMap();
        for(Entry<String, Class<?>> attribute : attributeMap.entrySet()) {
            String attributeName = attribute.getKey();
            Class<?> attributeClass = attribute.getValue();
            AntAttributeDefinitionSupport antAttributeDefinition = new AntAttributeDefinitionSupport(attributeName, attributeClass);
            result.add(antAttributeDefinition);
        }
    }
    
    public void fillNestedAntDefinitionList(LinkedList<AntDefinitionSupport> result) {
        Map<String, Class<?>> nestedElementMap = introspectionHelper.getNestedElementMap();
        for(Entry<String, Class<?>> nestedElementEntry : nestedElementMap.entrySet()) {
            String nestedElementName = nestedElementEntry.getKey().toLowerCase(Locale.ENGLISH);
            @SuppressWarnings("unchecked")
            Class<Object> nestedElementType = (Class<Object>) nestedElementEntry.getValue();
            IntrospectionHelper nestedIntrospectionHelper = IntrospectionHelper.getHelper(project, nestedElementType);
            AntDefinitionSupport antDefinitionSupport = new AntDefinitionSupport(project, nestedElementName, nestedElementType, nestedElementType, nestedIntrospectionHelper, true);
            result.add(antDefinitionSupport);
        }
    }
    
    public String getAntName() {
        return antName;
    }
    
    public Project getProject() {
        return project;
    }
    
    public IntrospectionHelper getIntrospectionHelper() {
        return introspectionHelper;
    }
    
    public Class<Object> getElementType() {
        return elementType;
    }
    
    public Class<Object> getEffectiveElementType() {
        return effectiveElementType;
    }
    
    public boolean isTask() {
        return !definitelyType && Task.class.isAssignableFrom(elementType);
    }
    
    public boolean isDataType() {
        return DataType.class.isAssignableFrom(elementType);
    }
    
    public boolean isTextSupported() {
        return introspectionHelper.supportsCharacters();
    }
    
    // needs to be implemented explicitly, because "dynamic" is a Ceylon keyword
    public boolean acceptsArbitraryNestedElementsOrAttributes() {
        return introspectionHelper.isDynamic();
    }
    
    public boolean isContainer() {
        return introspectionHelper.isContainer();
    }
    
}
