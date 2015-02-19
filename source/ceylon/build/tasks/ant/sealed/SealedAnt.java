package ceylon.build.tasks.ant.sealed;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.tools.ant.AntTypeDefinition;
import org.apache.tools.ant.BuildException;
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
            throw new SealedAntUsageException("Ant type <" + antName + "> is unknown.", null);
        }
        instantiateObject = antTypeDefinition.create(project);
        if (instantiateObject == null) {
            throw new SealedAntBackendException("Ant type <" + antName + "> has no known class instance.", null);
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
        try {
            introspectionHelper.setAttribute(getProject(), effectiveObject, name, value);
        } catch (RuntimeException e) {
            throw new SealedAntUsageException("Cannot add attribute " + name + " to Ant type <" + antName + ">.", e);
        }
        appliedAttributeMap.put(name, value);
    }
    
    public void storeNestedElement(SealedAnt element) {
        try {
            introspectionHelper.storeElement(getProject(), effectiveObject, element.effectiveObject, element.antName);
        } catch (RuntimeException e) {
            throw new SealedAntUsageException("Cannot store nested element <" + element.antName + "> in Ant type <" + antName + ">.", e);
        }
        appliedElements.add(element);
    }
    
    public void setText(String text) {
        try {
            introspectionHelper.addText(getProject(), effectiveObject, text);
        } catch (RuntimeException e) {
            throw new SealedAntUsageException("Cannot text of Ant type <" + antName + ">.", e);
        }
        appliedText = text;
    }
    
    public SealedAnt createNestedElement(String nestedElementName) {
        Creator creator;
        try {
            creator = introspectionHelper.getElementCreator(getProject(), "", effectiveObject, nestedElementName, null);
        } catch (RuntimeException e) {
            throw new SealedAntUsageException("Cannot create nested element <" + nestedElementName + "> in Ant type <" + antName + ">.", e);
        }
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
            try {
                task.execute();
            } catch (BuildException buildException) {
                throw new SealedAntBuildException(buildException.getMessage(), buildException);
            }
        } else {
            throw new SealedAntUsageException("Ant type " + antName + " is not an executable task.", null);
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

