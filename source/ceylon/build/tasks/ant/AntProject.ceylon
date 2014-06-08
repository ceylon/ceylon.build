import ceylon.build.tasks.ant.internal { AntProjectImplementation }

"Represents Ant's Project class, with the ability to access properties and Ant type definitions."
shared interface AntProject {

    shared formal Map<String,String> allProperties();
    
    shared formal String? getProperty(String propertyName);
    
    shared formal void setProperty(String propertyName, String? propertyValue);
    
    shared formal String effectiveBaseDirectory(String? newBaseDirectory = null);
    
    shared formal List<AntDefinition> allTopLevelAntDefinitions();
    
}

variable AntProjectImplementation? activeAntProjectImplementation = null;

AntProjectImplementation provideAntProjectImplementation() {
    AntProjectImplementation? antProjectImplementation = activeAntProjectImplementation;
    if(exists antProjectImplementation) {
        return antProjectImplementation;
    } else {
        AntProjectImplementation newAntProjectImplementation = AntProjectImplementation(null);
        activeAntProjectImplementation = newAntProjectImplementation;
        return newAntProjectImplementation;
    }
}

"Returns the active Ant project or provides a new one if not initialized."
shared AntProject activeAntProject() {
    return provideAntProjectImplementation();
}

"Creates a new Ant project and sets it as the active project. With optional base directory."
shared AntProject renewAntProject(String? baseDirectory) {
    AntProjectImplementation newAntProjectImplementation = AntProjectImplementation(baseDirectory);
    activeAntProjectImplementation = newAntProjectImplementation;
    return newAntProjectImplementation;
}
