import ceylon.language.meta.declaration { Module }
import ceylon.language.meta { modules }
import org.jboss.modules {
    JBossModule = Module { ceylonModuleLoader = callerModuleLoader },
    ModuleIdentifier { createModuleIdentifier = create }
}

Module? loadModule(String moduleArgument) {
    String moduleName;
    String moduleVersion;
    if (exists i = moduleArgument.firstInclusion("/")) {
        moduleName = moduleArgument[0..i-1];
        moduleVersion = moduleArgument[i+1...];
    } else {
        moduleName = moduleArgument;
        moduleVersion = "";
    }
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
