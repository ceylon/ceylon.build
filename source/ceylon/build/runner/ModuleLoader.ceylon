import ceylon.language.meta.declaration { Module }
import ceylon.language.meta { modules }
import org.jboss.modules {
    JBossModule = Module { ceylonModuleLoader = callerModuleLoader },
    ModuleIdentifier { createModuleIdentifier = create }
}

Module? loadModule(String moduleName, String moduleVersion) {
    loadModuleInClassPath(moduleName, moduleVersion);
    return modules.find(moduleName, moduleVersion);
}

void loadModuleInClassPath(String modName, String modVersion) {
    value modIdentifier = createModuleIdentifier(modName, modVersion);
    value mod = ceylonModuleLoader.loadModule(modIdentifier);
    value modClassLoader = mod.classLoader;
    value classToLoad = "``modName``.$module_";
    modClassLoader.loadClass(classToLoad);
}

"Exposes internal method [[loadModule]] for testing purposes."
shared Module? testAccessLoadModule(String moduleName, String moduleVersion) {
    return loadModule(moduleName, moduleVersion);
}
