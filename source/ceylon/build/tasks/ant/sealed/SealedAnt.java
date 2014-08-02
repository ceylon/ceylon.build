package ceylon.build.tasks.ant.sealed;

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
import org.apache.tools.ant.types.DataType;

public class SealedAnt {
    
    protected String antName;
    private SealedProject sealedProject;
    private Object instantiateObject;
    private Object effectiveObject;
    private IntrospectionHelper introspectionHelper;
    private List<SealedAnt> appliedElements = new ArrayList<SealedAnt>();
    private Map<String, Object> appliedAttributeMap = new HashMap<String, Object>();
    private String appliedText;
    
    public SealedAnt(String antName, SealedProject sealedProject) {
        this.antName= antName;
        this.sealedProject = sealedProject;
        Project project = getProject();
        ComponentHelper componentHelper = ComponentHelper.getComponentHelper(project);
        AntTypeDefinition antTypeDefinition = componentHelper.getDefinition(antName);
        if (antTypeDefinition == null) {
            throw new SealedAntException("Ant type <" + antName + "> is unknown.");
        }
        instantiateObject = antTypeDefinition.create(project);
        if (instantiateObject == null) {
            throw new SealedAntException("Ant type <" + antName + "> has no known class instance.");
        }
        if (instantiateObject instanceof TypeAdapter) {
            TypeAdapter typeAdapter = ((TypeAdapter) instantiateObject);
            typeAdapter.setProject(project);
            effectiveObject = typeAdapter.getProxy();
        } else {
            effectiveObject = instantiateObject;
        }
        introspectionHelper = IntrospectionHelper.getHelper(project, effectiveObject.getClass());
    }
    
    private Project getProject() {
        return sealedProject.getProject();
    }
    
    private SealedAnt(String nestedElementName, SealedProject sealedProject, Object instantiatedObject) {
        this.antName= nestedElementName;
        this.sealedProject = sealedProject;
        this.instantiateObject = instantiatedObject;
        effectiveObject = instantiatedObject;
        if (instantiatedObject instanceof TypeAdapter) {
            effectiveObject = ((TypeAdapter) instantiatedObject).getProxy();
        }
        introspectionHelper = IntrospectionHelper.getHelper(getProject(), effectiveObject.getClass());
    }
    
    public void attribute(String name, String value) {
        introspectionHelper.setAttribute(getProject(), effectiveObject, name, value);
        appliedAttributeMap.put(name, value);
    }
    
    public void element(SealedAnt element) {
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
    
    public SealedAnt createNestedElement(String nestedElementName) {
        Creator creator = introspectionHelper.getElementCreator(getProject(), "", effectiveObject, nestedElementName, null);
        Object object = creator.create();
        SealedAnt sealedAnt = new SealedAnt(nestedElementName, sealedProject, object);
        return sealedAnt;
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
            throw new SealedAntException("Ant type " + antName + " is not an executable task.");
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
        for(SealedAnt subElement : appliedElements) {
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

