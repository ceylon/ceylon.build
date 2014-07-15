import ceylon.build.tasks.ant.internal { AntProjectImplementation }

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
       Adds a module to the class loader, so Ant can use the classes.
       Needed if you want to use Ant types and tasks in external modules.
       Before actually using these types and tasks you have to initialize Ant with `typedef` or `taskdef`.
       
       Example:
       ```
       AntProject antProject = activeAntProject();
       antProject.addModule("org.apache.ant.ant-commons-net", "1.9.4");
       ant("taskdef", { "name" -> "ftp", "classname" -> "org.apache.tools.ant.taskdefs.optional.net.FTP" } );
       ```
    """
    shared formal void addModule(String moduleName, String moduleVersion = "");
    
    """
       Root of Ant type introspection.
       Gives all top level Ant defintions.
       Ant introspection works from top down, as the implementing classes of Ant types change depending on their location in the XML hierarchy.
    """
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

"""
   Returns the active Ant project or provides a new one if not initialized.
"""
shared AntProject activeAntProject() {
    return provideAntProjectImplementation();
}

"""
   Creates a new Ant project and sets it as the active project. With optional base directory.
"""
shared AntProject renewAntProject(String? baseDirectory) {
    AntProjectImplementation newAntProjectImplementation = AntProjectImplementation(baseDirectory);
    activeAntProjectImplementation = newAntProjectImplementation;
    return newAntProjectImplementation;
}
