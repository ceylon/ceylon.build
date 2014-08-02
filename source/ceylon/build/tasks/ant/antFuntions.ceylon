import ceylon.build.tasks.ant {
    AntProjectImplementation,
    AntProject
}
import ceylon.build.tasks.ant.internal {
    Gateway
}

"""
   Creates a new Ant project and sets it as the active project. With optional base directory.
   
   Usage:
   ```
   object moduleClassLoaderAccess satisfies ModuleClassLoaderAccess { }
   AntProject antProject =  initializeAnt(moduleClassLoaderAccess, baseDirectory);
   ```
"""
shared AntProject initializeAnt() {
    Gateway gateway = Gateway();
    AntProjectImplementation antProjectImplementation = AntProjectImplementation(gateway);
    activeAntProjectImplementation = antProjectImplementation;
    return antProjectImplementation;
}

"""
   Returns the active Ant project.
"""
shared AntProject activeAntProject() {
    return provideAntProjectImplementation();
}

variable AntProjectImplementation? activeAntProjectImplementation = null;

AntProjectImplementation provideAntProjectImplementation() {
    AntProjectImplementation? antProjectImplementation = activeAntProjectImplementation;
    "Before using Ant call initializeAnt(String? baseDirectory = null, {<String>*}? moduleDescriptors = null)"
    assert(exists antProjectImplementation);
    return antProjectImplementation;
}
