import ceylon.build.task { Task, Context }

String defaultModuleVersion = "1.0.0";

"Runs a Ceylon module using `ceylon run` command line."
shared Task runModule(
        doc("name of module to run")
        String moduleName,
        doc("version of module to run")
        String version = defaultModuleVersion,
        doc("Indicates that the default repositories should not be used
             (corresponding command line parameter: `--no-default-repositories`)")
        Boolean noDefaultRepositories = false,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String|{String*} repositories = [],
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Specifies the fully qualified name of a toplevel method or class with no parameters.
             (corresponding command line parameter: `--run=<toplevel>`)")
        String? functionNameToRun = null,
        doc("Produce verbose output.
             (corresponding command line parameter: `--verbose=<flags>`)")
        {RunVerboseMode*}|AllVerboseModes verboseModes = [],
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildRunCommand {
            ceylon;
            moduleName;
            version;
            noDefaultRepositories;
            offline;
            stringIterable(repositories);
            systemRepository;
            functionNameToRun;
            verboseModes;
            context.arguments;
        };
        return execute(context.writer, "running", command);
    };
}

"Runs a Ceylon module on node.js using `ceylon run-js` command line"
shared Task runJsModule(
        doc("name of module to run")
        String moduleName,
        doc("version of module to run")
        String version = defaultModuleVersion,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String|{String*} repositories = [],
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Specifies the fully qualified name of a toplevel method or class with no parameters.
             (corresponding command line parameter: `--run=<toplevel>`)")
        String? functionNameToRun = null,
        doc("Shows more detailed output in case of errors.
             (corresponding command line parameter: `--debug=<debug>`)")
        String? debug = null,
        doc("The path to the node.js executable. Will be searched in standard locations if not specified.
             (corresponding command line parameter: `--node-exe=<node-exe>`)")
        String? pathToNodeJs = null,
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildRunJsCommand {
            ceylon;
            moduleName;
            version;
            offline;
            stringIterable(repositories);
            systemRepository;
            functionNameToRun;
            debug;
            pathToNodeJs;
            context.arguments;
        };
        return execute(context.writer, "running", command);
    };
}