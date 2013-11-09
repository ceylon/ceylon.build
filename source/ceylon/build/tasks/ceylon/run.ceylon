import ceylon.build.task { Task, Context }

String defaultModuleVersion = "1.0.0";

"Runs a Ceylon module using `ceylon run` command line."
shared Task runModule(
        "name of module to run"
        String moduleName,
        "version of module to run"
        String version = defaultModuleVersion,
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
            currentWorkingDirectory;
            moduleName;
            version;
            noDefaultRepositories;
            offline;
            stringIterable(repositories);
            systemRepository;
            cacheRepository;
            functionNameToRun;
            verboseModes;
            context.arguments;
        };
        return execute(context.writer, "running", ceylon, command);
    };
}

"Runs a Ceylon module on node.js using `ceylon run-js` command line"
shared Task runJsModule(
        "name of module to run"
        String moduleName,
        "version of module to run"
        String version = defaultModuleVersion,
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
        "Shows more detailed output in case of errors.
         (corresponding command line parameter: `--debug=<debug>`)"
        String? debug = null,
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
            currentWorkingDirectory;
            moduleName;
            version;
            offline;
            stringIterable(repositories);
            systemRepository;
            cacheRepository;
            functionNameToRun;
            debug;
            pathToNodeJs;
            context.arguments;
        };
        return execute(context.writer, "running", ceylon, command);
    };
}