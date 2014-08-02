import ceylon.build.tasks.ant.internal {
    Gateway
}
import ceylon.collection {
    ArrayList
}

import java.lang {
    JString=String
}
import java.util {
    JList=List
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

class AntProjectImplementation(gateway) satisfies AntProject {
    
    shared Gateway gateway;
    shared Object sealedProject = gateway.instatiate("SealedProject");
    
    shared actual Map<String,String> allProperties() {
        Anything allProperties = gateway.invoke(sealedProject, "getAllProperties");
        return toStringMap(allProperties);
    }
    
    shared actual String? getProperty(String propertyName) {
        Anything property = gateway.invoke(sealedProject, "getProperty", JString(propertyName));
        return toStringOrNull(property);
    }
    
    shared actual void setProperty(String propertyName, String? propertyValue) {
        switch (propertyValue)
        case (is Null) {
            gateway.invoke(sealedProject, "unsetProperty", JString(propertyName));
        }
        case (is String) {
            gateway.invoke(sealedProject, "setProperty", JString(propertyName), JString(propertyValue));
        }
    }
    
    shared actual String effectiveBaseDirectory(String? newBaseDirectory) {
        if(exists newBaseDirectory) {
            gateway.invoke(sealedProject, "setBaseDirectory", JString(newBaseDirectory));
        }
        Anything baseDirectory = gateway.invoke(sealedProject, "getBaseDirectory");
        return toString(baseDirectory);
    }
    
    shared actual List<AntDefinition> allTopLevelAntDefinitions() {
        Anything sealedAntDefinitions = gateway.invoke(sealedProject, "getTopLevelSealedAntDefinitions");
        "Java List expected."
        assert(is JList<out Anything> sealedAntDefinitions);
        ArrayList<AntDefinition> allTopLevelAntDefinitions = ArrayList<AntDefinition>();
        value jIterator = sealedAntDefinitions.iterator();
        while (jIterator.hasNext()){
            Anything sealedAntDefinition = jIterator.next();
            assert(is Object sealedAntDefinition);
            AntDefinition topLevelAntDefinition = AntDefinitionImplementation(gateway, sealedAntDefinition);
            allTopLevelAntDefinitions.add(topLevelAntDefinition);
        }
        List<AntDefinition> sortedTopLevelAntDefinitions = allTopLevelAntDefinitions.sort(byIncreasing((AntDefinition a) => a));
        return sortedTopLevelAntDefinitions;
    }
    
    shared actual void loadModuleClasses(String moduleName, String moduleVersion) {
        gateway.loadModuleClasses(moduleName, moduleVersion);
    }
    
    shared actual void loadUrlClasses(String url) {
        gateway.loadUrlClasses(url);
    }
    
}
