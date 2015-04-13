import ceylon.language.meta.declaration { Module }
import ceylon.language.meta { modules }
import org.jboss.modules {
	M = Module {
		ceylonModuleLoader=callerModuleLoader
	},
	ModuleIdentifier {
		createModuleIdentifier=create
	}
}
 
Module? loadModule(String moduleName, String moduleVersion) {
    value moduleIdentifier = createModuleIdentifier(moduleName, moduleVersion);
    value mod = ceylonModuleLoader.loadModule(moduleIdentifier);
    value moduleClassLoader = mod.classLoader;
    value classToLoad = "``moduleName``.$module_";
    moduleClassLoader.loadClass(classToLoad);
    return modules.find(moduleName, moduleVersion);
}

"Exposes internal method [[loadModule]] for testing purposes."
shared Module? testAccessLoadModule(String moduleName, String moduleVersion) {
    return loadModule(moduleName, moduleVersion);
}
