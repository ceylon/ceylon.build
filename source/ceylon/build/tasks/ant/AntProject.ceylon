import ceylon.build.tasks.ant.internal {
    ProjectSupport,
    AntDefinitionSupport
}
import ceylon.collection {
    HashMap,
    LinkedList
}

"""
   Represents Ant's Project class, with the ability to access properties and Ant type definitions.
"""
shared interface AntProject {
    
    """
       Gives all available Ant properties in this project.
    """
    shared formal Map<String,String> allProperties();
    
    """
       Gives a specific Ant property.
    """
    shared formal String? getProperty(String propertyName);
    
    """
       Sets an Ant property.
    """
    shared formal void setProperty(String propertyName, String? propertyValue);
    
    """
       Sets a new base directory for the current Ant project.
    """
    shared formal String effectiveBaseDirectory(String? newBaseDirectory = null);
    
    """
       Root of Ant type introspection.
       Gives all top level Ant defintions.
       Ant introspection works from top down, as the implementing classes of Ant types change depending on their location in the XML hierarchy.
    """
    shared formal List<AntDefinition> allTopLevelAntDefinitions();
    
    """
       Loads classes from a given module so that they are accessible from Ant.
       Before using loaded classes as types/tasks, you have to register them with Ant.
       For registering either use `<typedef>`/`<taskdef>` or any of [[registerAntLibrary]], [[registerAntType]], [[registerAntTask]].
    """
    shared formal void loadModuleClasses(String moduleName, String moduleVersion = "");
    
    """
       Loads classes from a given URL so that they are accessible from Ant.
       Before using loaded classes as types/tasks, you have to register them with Ant.
       For registering either use `<typedef>`/`<taskdef>` or any of [[registerAntLibrary]], [[registerAntType]], [[registerAntTask]].
    """
    shared formal void loadUrlClasses(String url);
    
}

class AntProjectImplementation(projectSupport) satisfies AntProject {
    
    shared ProjectSupport projectSupport;
    
    shared actual Map<String,String> allProperties() {
        HashMap<String,String> result = HashMap<String,String>();
        projectSupport.fillAllPropertiesMap(result);
        return result;
    }
    
    shared actual String? getProperty(String propertyName) {
        return projectSupport.getProperty(propertyName);
    }
    
    shared actual void setProperty(String propertyName, String? propertyValue) {
        projectSupport.setProperty(propertyName, propertyValue);
    }
    
    shared actual String effectiveBaseDirectory(String? newBaseDirectory) {
        if(exists newBaseDirectory) {
            projectSupport.baseDirectory = newBaseDirectory;
        }
        return projectSupport.baseDirectory;
    }
    
    shared actual List<AntDefinition> allTopLevelAntDefinitions() {
        LinkedList<AntDefinitionSupport> topLevelAntDefinitionSupportList = LinkedList<AntDefinitionSupport>();
        projectSupport.fillTopLevelAntDefinitionSupportList(topLevelAntDefinitionSupportList);
        LinkedList<AntDefinition> allTopLevelAntDefinitions = LinkedList<AntDefinition>();
        for (topLevelAntDefinitionSupport in topLevelAntDefinitionSupportList) {
            AntDefinition topLevelAntDefinition = AntDefinitionImplementation(topLevelAntDefinitionSupport);
            allTopLevelAntDefinitions.add(topLevelAntDefinition);
        }
        AntDefinition[] sortedTopLevelAntDefinitions = allTopLevelAntDefinitions.sort(byIncreasing((AntDefinition a) => a));
        return sortedTopLevelAntDefinitions;
    }
    
    shared actual void loadModuleClasses(String moduleName, String moduleVersion) {
        projectSupport.loadModuleClasses(moduleName, moduleVersion);
    }
    
    shared actual void loadUrlClasses(String url) {
        projectSupport.loadUrlClasses(url);
    }
    
}
