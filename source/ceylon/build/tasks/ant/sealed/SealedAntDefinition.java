package ceylon.build.tasks.ant.sealed;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.tools.ant.IntrospectionHelper;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.DataType;

public class SealedAntDefinition {
    
    private Project project;
    private String antName;
    private Class<Object> elementType;
    private Class<Object> effectiveElementType;
    private IntrospectionHelper introspectionHelper;
    private boolean definitelyType;
    
    // Package private constructor to ensure correct class loader.
    SealedAntDefinition(Project project, String antName, Class<Object> elementType, Class<Object> effectiveElementType, IntrospectionHelper introspectionHelper, boolean definitelyType) {
        this.project = project;
        this.antName = antName;
        this.elementType = elementType;
        this.effectiveElementType = effectiveElementType;
        this.introspectionHelper = introspectionHelper;
        this.definitelyType = definitelyType;
    }
    
    public List<String[]> getAttributeDefinitions() {
        List<String[]> attributeDefinitions = new ArrayList<String[]>();
        Map<String, Class<?>> attributeMap = introspectionHelper.getAttributeMap();
        for(Entry<String, Class<?>> attribute : attributeMap.entrySet()) {
            String attributeName = attribute.getKey();
            Class<?> attributeClass = attribute.getValue();
            String[] attributeDefinition = new String[] { attributeName, attributeClass.getName() };
            attributeDefinitions.add(attributeDefinition);
        }
        return attributeDefinitions;
    }
    
    public List<SealedAntDefinition> getNestedAntDefinitions() {
        List<SealedAntDefinition> nestedAntDefinitions = new ArrayList<SealedAntDefinition>();
        Map<String, Class<?>> nestedElementMap = introspectionHelper.getNestedElementMap();
        for(Entry<String, Class<?>> nestedElementEntry : nestedElementMap.entrySet()) {
            String nestedElementName = nestedElementEntry.getKey().toLowerCase(Locale.ENGLISH);
            @SuppressWarnings("unchecked")
            Class<Object> nestedElementType = (Class<Object>) nestedElementEntry.getValue();
            IntrospectionHelper nestedIntrospectionHelper = IntrospectionHelper.getHelper(project, nestedElementType);
            SealedAntDefinition sealedAntDefinition = new SealedAntDefinition(project, nestedElementName, nestedElementType, nestedElementType, nestedIntrospectionHelper, true);
            nestedAntDefinitions.add(sealedAntDefinition);
        }
        return nestedAntDefinitions;
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
    
    public String getElementType() {
        return elementType.getName();
    }
    
    public String getEffectiveElementType() {
        return effectiveElementType.getName();
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
