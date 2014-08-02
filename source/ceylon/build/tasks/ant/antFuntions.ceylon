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
shared AntProject createAntProject() {
    Gateway gateway = Gateway();
    AntProjectImplementation antProjectImplementation = AntProjectImplementation(gateway);
    return antProjectImplementation;
}
