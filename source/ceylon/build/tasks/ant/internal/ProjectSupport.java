package ceylon.build.tasks.ant.internal;

import java.io.File;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Map.Entry;

import org.apache.tools.ant.AntTypeDefinition;
import org.apache.tools.ant.ComponentHelper;
import org.apache.tools.ant.IntrospectionHelper;
import org.apache.tools.ant.Project;

import ceylon.collection.HashMap;
import ceylon.collection.LinkedList;

public class ProjectSupport {

    Project project;
    
    public ProjectSupport(String baseDirectory) {
        project = ProjectCreator.createProject();
        if(baseDirectory != null) {
            project.setBaseDir(new File(baseDirectory));
        }
    }
    
    public Project getProject() {
        return project;
    }
    
    public void fillAllPropertiesMap(HashMap<ceylon.language.String, ceylon.language.String> result) {
        Hashtable<String, Object> properties = project.getProperties();
        for(String propertyName : properties.keySet()) {
            Object propertyObject = properties.get(propertyName);
            if(propertyObject != null) {
                String propertyValue = propertyObject.toString();
                ceylon.language.String propertyNameCeylonString = new ceylon.language.String(propertyName);
                ceylon.language.String propertyValueCeylonString = new ceylon.language.String(propertyValue);
                result.put(propertyNameCeylonString, propertyValueCeylonString);
            }
        }
    }
    
    public String getProperty(String propertyName) {
        return project.getProperty(propertyName);
    }
    
    public void setProperty(String propertyName, String propertyValue) {
        project.setProperty(propertyName, propertyValue);
    }
    
    public String getBaseDirectory() {
        return project.getBaseDir().toString();
    }
    
    public void setBaseDirectory(String newBaseDirectory) {
        project.setBaseDir(new File(newBaseDirectory));
    }
    
    public void fillTopLevelAntDefinitionSupportList(LinkedList<AntDefinitionSupport> result) {
        ComponentHelper componentHelper = ComponentHelper.getComponentHelper(project);
        Hashtable<String, AntTypeDefinition> antTypeTable = componentHelper.getAntTypeTable();
        for(Entry<String, AntTypeDefinition> antTypeEntry : antTypeTable.entrySet()) {
            try {
                String antName = antTypeEntry.getKey().toLowerCase(Locale.ENGLISH);
                AntTypeDefinition antTypeDefinition = componentHelper.getDefinition(antName);
                @SuppressWarnings("unchecked")
                Class<Object> instantiatedType = (Class<Object>) antTypeDefinition.create(project).getClass();
                IntrospectionHelper introspectionHelper = IntrospectionHelper.getHelper(project, instantiatedType);
                AntDefinitionSupport antDefinitionSupport = new AntDefinitionSupport(project, antName, instantiatedType, introspectionHelper, false);
                result.add(antDefinitionSupport);
            } catch (Exception exception) {
                // continue with next Ant type, most likely couldn't instantiate object
            }
        }
    }
    
    public IntrospectionHelper introspectionHelper(String antName, Class<Object> instantiatedClass) {
        try {
            Project project = getProject();
            IntrospectionHelper introspectionHelper = IntrospectionHelper.getHelper(project, instantiatedClass);
            return introspectionHelper;
        } catch (Throwable throwable) {
            return null;
        }
    }
    
}
