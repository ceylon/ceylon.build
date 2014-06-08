package ceylon.build.tasks.ant.internal;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.tools.ant.AntTypeDefinition;
import org.apache.tools.ant.ComponentHelper;
import org.apache.tools.ant.IntrospectionHelper;
import org.apache.tools.ant.IntrospectionHelper.Creator;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.DataType;

public class AntSupport {

    protected String antName;
    private ProjectSupport projectSupport;
    private Object instantiatedType;
    private IntrospectionHelper introspectionHelper;
    private List<AntSupport> appliedElements = new ArrayList<AntSupport>();
    private Map<String, Object> appliedAttributeMap = new HashMap<String, Object>();
    private String appliedText;
    
    public AntSupport() {
    }
    
    public AntSupport(String antName, ProjectSupport projectSupport) {
        this.antName= antName;
        this.projectSupport = projectSupport;
        Project project = getProject();
        ComponentHelper componentHelper = ComponentHelper.getComponentHelper(project);
        AntTypeDefinition antTypeDefinition = componentHelper.getDefinition(antName);
        instantiatedType = antTypeDefinition.create(project);
        introspectionHelper = IntrospectionHelper.getHelper(project, instantiatedType.getClass());
    }
    
    private Project getProject() {
        return projectSupport.getProject();
    }

    private AntSupport(String nestedElementName, ProjectSupport projectSupport, Object instantiatedType) {
        this.antName= nestedElementName;
        this.projectSupport = projectSupport;
        this.instantiatedType = instantiatedType;
        introspectionHelper = IntrospectionHelper.getHelper(getProject(), instantiatedType.getClass());
    }
    
    public void attribute(String name, Object value) {
        introspectionHelper.setAttribute(getProject(), instantiatedType, name, value);
        appliedAttributeMap.put(name, value);
    }
    
    public void element(AntSupport element) {
        introspectionHelper.storeElement(getProject(), instantiatedType, element.instantiatedType, element.antName);
        appliedElements.add(element);
    }
    
    public void setText(String text) {
        introspectionHelper.addText(getProject(), instantiatedType, text);
        appliedText = text;
    }
    
    public Map<String, Class<?>> getAttributeMap() {
        Map<String, Class<?>> attributeMap = introspectionHelper.getAttributeMap();
        return attributeMap;
    }
    
    public Map<String, Class<?>> getElementMap () {
        Map<String, Class<?>> nestedElementMap = introspectionHelper.getNestedElementMap();
        return nestedElementMap;
    }
    
    public AntSupport createNestedElement(String nestedElementName) {
        Creator creator = introspectionHelper.getElementCreator(getProject(), "", instantiatedType, nestedElementName, null);
        Object object = creator.create();
        AntSupport antSupport = new AntSupport(nestedElementName, projectSupport, object);
        return antSupport;
    }
    
    public String getAntName() {
        return antName;
    }
    
    public boolean isTask() {
        return instantiatedType instanceof Task;
    }
    
    public boolean isDataType() {
        return instantiatedType instanceof DataType;
    }
    
    public boolean isTextSupported() {
        return introspectionHelper.supportsCharacters();
    }
    
    // needs to be implemented explicitly, because "dynamic" is a Ceylon keyword
    public boolean isDynamicType() {
        return introspectionHelper.isDynamic();
    }
    
    public boolean isContainer() {
        return introspectionHelper.isContainer();
    }
    
    public Object getInstantiatedType() {
        return instantiatedType;
    }
    
    public void execute() {
        if(isTask()) {
            Task task = (Task) instantiatedType;
            task.execute();
        } else {
            throw new AntSupportException("Ant type " + antName + " is not an executable task.");
        }
    }
    
    public String toString() {
        String result = "<" + antName;
        List<String> attributeNames = new ArrayList<String>(appliedAttributeMap.keySet());
        Collections.sort(attributeNames);
        for(String attributeName : attributeNames) {
            Object attributeValue = appliedAttributeMap.get(attributeName);
            result += " " + attributeName + "=\"" + attributeValue + "\"";
        }
        if(appliedText != null || appliedElements.size() > 0) {
            result += ">";
        }
        for(AntSupport subElement : appliedElements) {
            result += subElement.toString();
        }
        if(appliedText != null) {
            result += appliedText + "</" + antName + ">";
        } else if (appliedElements.size() > 0) {
            result += "</" + antName + ">";
        } else {
            result += "/>";
        }
        return result;
    }
    
}

