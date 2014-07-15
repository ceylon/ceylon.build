package ceylon.build.tasks.ant.internal;

import java.io.File;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Map.Entry;

import org.apache.tools.ant.AntTypeDefinition;
import org.apache.tools.ant.ComponentHelper;
import org.apache.tools.ant.IntrospectionHelper;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.TypeAdapter;
import org.jboss.modules.ModuleLoadException;

import ceylon.build.tasks.ant.internal.ProjectCreator.ProjectTuple;
import ceylon.collection.HashMap;
import ceylon.collection.LinkedList;

public class ProjectSupport {
    
    private Project project;
    private MultiModuleClassLoader multiModuleClassLoader;
    
    public ProjectSupport(String baseDirectory) {
        ProjectTuple projectTuple = ProjectCreator.createProject();
        project = projectTuple.project;
        multiModuleClassLoader = projectTuple.multiModuleClassLoader;
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
    
    public void addModule(String moduleName, String moduleVersion) throws ModuleLoadException, ClassNotFoundException {
        multiModuleClassLoader.addModule(moduleName, moduleVersion);
    }
    
    public ClassLoader getClassLoader() {
        return multiModuleClassLoader;
    }
    
    public void fillTopLevelAntDefinitionSupportList(LinkedList<AntDefinitionSupport> result) {
        ComponentHelper componentHelper = ComponentHelper.getComponentHelper(project);
        Hashtable<String, AntTypeDefinition> antTypeTable = componentHelper.getAntTypeTable();
        for(Entry<String, AntTypeDefinition> antTypeEntry : antTypeTable.entrySet()) {
            try {
                String antName = antTypeEntry.getKey().toLowerCase(Locale.ENGLISH);
                AntTypeDefinition antTypeDefinition = componentHelper.getDefinition(antName);
                Object instantiateObject = antTypeDefinition.create(project);
                Object effectiveObject = instantiateObject;
                if (instantiateObject instanceof TypeAdapter) {
                    effectiveObject = ((TypeAdapter) instantiateObject).getProxy();
                }
                @SuppressWarnings("unchecked")
                Class<Object> instantiatedType = (Class<Object>) instantiateObject.getClass();
                @SuppressWarnings("unchecked")
                Class<Object> effectiveType = (Class<Object>) effectiveObject.getClass();
                IntrospectionHelper introspectionHelper = IntrospectionHelper.getHelper(project, effectiveType);
                AntDefinitionSupport antDefinitionSupport = new AntDefinitionSupport(project, antName, instantiatedType, effectiveType, introspectionHelper, false);
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
