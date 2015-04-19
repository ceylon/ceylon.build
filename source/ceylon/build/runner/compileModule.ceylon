import com.redhat.ceylon.common.tools {
    CeylonTool,
    CeylonToolLoader
}
import org.jboss.modules {
    JBossModule = Module { ceylonModuleLoader = callerModuleLoader },
    ModuleIdentifier { createModuleIdentifier = create }
}

// @TODO Implement: Determine if compile is required.
Boolean rebuildRequired(String moduleName, String moduleVersion) {
    String buildModuleSubDirectory = moduleName.replace(".", "/");
    // @TODO needs to determine cache or actually use cache
    String buildModuleCar = "/``buildModuleSubDirectory``/``moduleVersion``/``moduleName``-``moduleVersion``.car";
    return true;
}

void compileModule(Options commandLineOptions) {
    value rebuild = rebuildRequired(commandLineOptions.moduleName, commandLineOptions.moduleVersion);
    if (rebuild) {
        print("Compiling build script for ``commandLineOptions.moduleName``/``commandLineOptions.moduleVersion``");
        {String*} compilerOptions = commandLineOptions.compilation.buildCompilerOptions();
        CeylonTool tool = CeylonTool();
        value compilerToolLoader = loadJavaModule("com.redhat.ceylon.compiler.java", language.version);
        tool.setToolLoader(compilerToolLoader);
        tool.bootstrap(*compilerOptions);
    }
}

CeylonToolLoader loadJavaModule(String name, String? version) {
    value identifier = createModuleIdentifier(name, version);
    value jbossModule = ceylonModuleLoader.loadModule(identifier);
    value classLoader = jbossModule.classLoader;
    return CeylonToolLoader(classLoader);
}
