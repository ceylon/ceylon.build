import ceylon.language.meta.declaration { Module }
import ceylon.language.meta { modules }
import ceylon.modules.jboss.runtime { CeylonModuleLoader }
import org.jboss.modules {
    M = Module {
         ceylonModuleLoader=callerModuleLoader
    }
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
    assert(is CeylonModuleLoader loader = ceylonModuleLoader);
    loader.loadModuleSynchronous(modName, modVersion);
}
