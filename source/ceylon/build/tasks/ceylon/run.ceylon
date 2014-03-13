import ceylon.build.task { context }

"Runs a Ceylon module using `ceylon run` tool."
shared void runModule(
        "name of module to run"
        String moduleName,
        "version of module to run"
        String? version = defaultModuleVersion,
        "Arguments to be passed to executed module"
        {String*} moduleArguments = [],
        "Indicates that the default repositories should not be used
         (corresponding command line parameter: `--no-default-repositories`)"
        Boolean noDefaultRepositories = false,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline = false,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        String|{String*} repositories = [],
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository = null,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository = null,
        "Specifies the fully qualified name of a toplevel method or class with no parameters.
         (corresponding command line parameter: `--run=<toplevel>`)"
        String? functionNameToRun = null,
        "Determines if and how compilation should be handled.
         (corresponding command line parameter: `--compile[=<flags>]`)"
        CompileOnRun? compileOnRun = null,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties = [],
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {RunVerboseMode*}|AllVerboseModes verboseModes = [],
        "Ceylon executable that will be used"
        String ceylon = ceylonExecutable,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
) {
    value command = runCommand {
        RunArguments {
            moduleName = moduleName;
            version = version;
            moduleArguments = moduleArguments;
            noDefaultRepositories = noDefaultRepositories;
            offline = offline;
            repositories = stringIterable(repositories);
            systemRepository = systemRepository;
            cacheRepository = cacheRepository;
            functionNameToRun = functionNameToRun;
            compileOnRun = compileOnRun;
            systemProperties = systemProperties;
            verboseModes = verboseModes;
            currentWorkingDirectory = currentWorkingDirectory;
        };
    };
    execute(context.writer, "running", ceylon, command);
}

"Builds a ceylon run command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] runCommand(RunArguments args) {
    value command = initCommand("run");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendNoDefaultRepositories(args.noDefaultRepositories));
    command.add(appendOfflineMode(args.offline));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendRun(args.functionNameToRun));
    command.add(appendCompileOnRun(args.compileOnRun));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.add(appendModule(args.moduleName, args.version));
    command.addAll(appendModuleArguments(args.moduleArguments));
    return cleanCommand(command);
}
