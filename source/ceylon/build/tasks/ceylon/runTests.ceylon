import ceylon.build.task { Context, Task }

"Runs tests of Ceylon module using `ceylon test` command line."
shared Task runTests(
    "name/version of modules to test"
    see(`function moduleVersion`)
    String|{String*} modules,
    "Specifies which tests will be run.
     (corresponding command line parameter: `--test=<test>`)"
    String|{String*} tests = [],
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
    "Determines if and how compilation should be handled.
     (corresponding command line parameter: `--compile[=<flags>]`)"
    CompileOnRun? compileOnRun = null,
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    {<String->String>*} systemProperties = [],
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    {RunTestsVerboseMode*}|AllVerboseModes verboseModes = [],
    "Ceylon executable that will be used"
    String ceylon = ceylonExecutable,
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    String? currentWorkingDirectory = null
) {
    return function(Context context) {
        value command = runTestsCommand {
            currentWorkingDirectory = currentWorkingDirectory;
            modules = stringIterable(modules);
            tests = stringIterable(tests);
            noDefaultRepositories = noDefaultRepositories;
            offline = offline;
            repositories = stringIterable(repositories);
            systemRepository = systemRepository;
            cacheRepository = cacheRepository;
            compileOnRun = compileOnRun;
            systemProperties = systemProperties;
            verboseModes = verboseModes;
            arguments = context.arguments;
        };
        return execute(context.writer, "testing", ceylon, command);
    };
}