import ceylon.build.task { Task, Context }

"Default module version (1.0.0)"
shared String? defaultModuleVersion = null;

"Build a module name/version string from a name and a version"
shared String moduleVersion(String name, String? version = defaultModuleVersion) {
    if (exists version) {
        return "``name``/``version``";
    }
    return name;
}

"Compile on run flag"
shared interface CompileOnRun of never | once | force | check {}
"Never attempt to compile"
shared object never satisfies CompileOnRun { string => "never"; }
"Compile only if not compiled"
shared object once satisfies CompileOnRun { string => "once"; }
"Always compile"
shared object force satisfies CompileOnRun { string => "force"; }
"Check and compile if needed"
shared object check satisfies CompileOnRun { string => "check"; }

"Runs a Ceylon module using `ceylon run` tool."
shared Task runModule(
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
    return function(Context context) {
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
                arguments = context.arguments;
            };
        };
        return execute(context.writer, "running", ceylon, command);
    };
}

"Runs a Ceylon module on node.js using `ceylon run-js` tool."
shared Task runJsModule(
        "name of module to run"
        String moduleName,
        "version of module to run"
        String? version = defaultModuleVersion,
        "Arguments to be passed to executed module"
        {String*} moduleArguments = [],
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
        "Shows more detailed output in case of errors.
         (corresponding command line parameter: `--debug=<debug>`)"
        String? debug = null,
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {RunJsVerboseMode*}|AllVerboseModes verboseModes = [],
        "The path to the node.js executable. Will be searched in standard locations if not specified.
         (corresponding command line parameter: `--node-exe=<node-exe>`)"
        String? pathToNodeJs = null,
        "Ceylon executable that will be used or null to use current ceylon tool"
        String? ceylon = null,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
) {
    return function(Context context) {
        value command = runJsCommand {
            currentWorkingDirectory = currentWorkingDirectory;
            moduleName = moduleName;
            version = version;
            moduleArguments = moduleArguments;
            offline = offline;
            repositories = stringIterable(repositories);
            systemRepository = systemRepository;
            cacheRepository = cacheRepository;
            functionNameToRun = functionNameToRun;
            compileOnRun = compileOnRun;
            systemProperties = systemProperties;
            debug = debug;
            verboseModes = verboseModes;
            pathToNodeJs = pathToNodeJs;
            arguments = context.arguments;
        };
        return execute(context.writer, "running", ceylon, command);
    };
}