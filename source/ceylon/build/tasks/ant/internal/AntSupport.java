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
import org.apache.tools.ant.TypeAdapter;
import org.apache.tools.ant.taskdefs.AntlibDefinition;
import org.apache.tools.ant.types.DataType;

public class AntSupport {
    
    protected String antName;
    private ProjectSupport projectSupport;
    private Object instantiateObject;
    private Object effectiveObject;
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
        if (antTypeDefinition == null) {
            throw new AntSupportException("Ant type <" + antName + "> is unknown.");
        }
        instantiateObject = antTypeDefinition.create(project);
        if (instantiateObject == null) {
            throw new AntSupportException("Ant type <" + antName + "> has no known class instance.");
        }
        if (instantiateObject instanceof TypeAdapter) {
            TypeAdapter typeAdapter = ((TypeAdapter) instantiateObject);
            typeAdapter.setProject(project);
            effectiveObject = typeAdapter.getProxy();
        } else {
            effectiveObject = instantiateObject;
        }
        if (effectiveObject instanceof AntlibDefinition) {
            AntlibDefinition antlibDefinition = (AntlibDefinition) effectiveObject;
            antlibDefinition.setAntlibClassLoader(this.projectSupport.getClassLoader());
        }
        introspectionHelper = IntrospectionHelper.getHelper(project, effectiveObject.getClass());
    }
    
    private Project getProject() {
        return projectSupport.getProject();
    }

    private AntSupport(String nestedElementName, ProjectSupport projectSupport, Object instantiatedObject) {
        this.antName= nestedElementName;
        this.projectSupport = projectSupport;
        this.instantiateObject = instantiatedObject;
        effectiveObject = instantiatedObject;
        if (instantiatedObject instanceof TypeAdapter) {
            effectiveObject = ((TypeAdapter) instantiatedObject).getProxy();
        }
        introspectionHelper = IntrospectionHelper.getHelper(getProject(), effectiveObject.getClass());
    }
    
    public void attribute(String name, Object value) {
        introspectionHelper.setAttribute(getProject(), effectiveObject, name, value);
        appliedAttributeMap.put(name, value);
    }
    
    public void element(AntSupport element) {
        introspectionHelper.storeElement(getProject(), effectiveObject, element.effectiveObject, element.antName);
        appliedElements.add(element);
    }
    
    public void setText(String text) {
        introspectionHelper.addText(getProject(), effectiveObject, text);
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
        Creator creator = introspectionHelper.getElementCreator(getProject(), "", effectiveObject, nestedElementName, null);
        Object object = creator.create();
        AntSupport antSupport = new AntSupport(nestedElementName, projectSupport, object);
        return antSupport;
    }
    
    public String getAntName() {
        return antName;
    }
    
    public boolean isTask() {
        return instantiateObject instanceof Task;
    }
    
    public boolean isDataType() {
        return instantiateObject instanceof DataType;
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
    
    public Object getInstantiatedObject() {
        return instantiateObject;
    }
    
    public Object getEffectiveObject() {
        return effectiveObject;
    }
    
    public void execute() {
        if(isTask()) {
            Task task = (Task) instantiateObject;
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

