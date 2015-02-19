import ceylon.build.task {
    setContextForTask,
    Writer,
    clearTaskContext
}
import ceylon.build.tasks.ceylon {
    compile
}

// @TODO Implement: Determine if compile is required.
Boolean rebuildRequired(String moduleName, String moduleVersion) {
    String buildModuleSubDirectory = moduleName.replace(".", "/");
    // needs to determine cache or actually use cache
    suppressWarnings("unusedDeclaration")
    String buildModuleCar = "/``buildModuleSubDirectory``/``moduleVersion``/``moduleName``-``moduleVersion``.car";
    return true;
}

CompileInfo compileModule(CommandLineOptions commandLineOptions, Writer writer) {
    "Module to compile and execute required"
    assert (is String buildModule = commandLineOptions.buildModule);
    value nameAndVersion = moduleNameAndVersion(buildModule);
    {String*} sourceDirectories;
    if (commandLineOptions.sourceDirectories.size > 0) {
        sourceDirectories = {*commandLineOptions.sourceDirectories};
    } else {
        sourceDirectories = {"build-source"};
    }
    value rebuild = rebuildRequired(nameAndVersion[0], nameAndVersion[1]);
    if (rebuild) {
        setContextForTask([], writer);
        writer.info("Compiling build script for ``nameAndVersion[0]``/``nameAndVersion[1]``");
        compile {
            modules = nameAndVersion[0];
            encoding = commandLineOptions.encoding;
            sourceDirectories = sourceDirectories;
            resourceDirectories = commandLineOptions.resourceDirectories;
            javacOptions = commandLineOptions.javacOptions;
            repositories = commandLineOptions.repositories;
            systemRepository = commandLineOptions.systemRepository;
            cacheRepository = commandLineOptions.cacheRepository;
            offline = commandLineOptions.offline;
            noDefaultRepositories = commandLineOptions.noDefaultRepositories;
            systemProperties = commandLineOptions.systemProperties;
            currentWorkingDirectory = commandLineOptions.currentWorkingDirectory;
        };
        clearTaskContext();
    }
    return CompileInfo(nameAndVersion[0], nameAndVersion[1]);
}

[String,String] moduleNameAndVersion(String moduleArgument) {
    String moduleName;
    String moduleVersion;
    if (exists i = moduleArgument.firstInclusion("/")) {
        moduleName = moduleArgument[0..i-1];
        moduleVersion = moduleArgument[i+1...];
    } else {
        moduleName = moduleArgument;
        moduleVersion = "";
    }
    return [moduleName, moduleVersion];
}

class CompileInfo(buildModuleName, buildModuleVersion) {
    shared String buildModuleName;
    shared String buildModuleVersion;
}
