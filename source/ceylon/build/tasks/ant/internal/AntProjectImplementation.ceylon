import ceylon.collection { HashMap, LinkedList }

import ceylon.build.tasks.ant { AntDefinition, AntProject }

shared class AntProjectImplementation(String? baseDirectory) satisfies AntProject {
    
    shared ProjectSupport projectSupport = ProjectSupport(baseDirectory);
    
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
    
    shared actual void addModule(String moduleName, String moduleVersion) {
        projectSupport.addModule(moduleName, moduleVersion);
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
    
}
