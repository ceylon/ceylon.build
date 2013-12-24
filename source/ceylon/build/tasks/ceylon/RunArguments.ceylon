"Holds arguments to be passed to ceylon run tool."
shared class RunArguments(
    moduleName,
    version = defaultModuleVersion,
    moduleArguments = [],
    noDefaultRepositories = false,
    offline = false,
    repositories = [],
    systemRepository = null,
    cacheRepository = null,
    functionNameToRun = null,
    compileOnRun = null,
    systemProperties = [],
    verboseModes = [],
    currentWorkingDirectory = null,
    arguments = []) {
    
    "name of module to run"
    shared String moduleName;
    
    "version of module to run"
    shared String? version;
    
    "Arguments to be passed to executed module"
    shared {String*} moduleArguments;
    
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared Boolean noDefaultRepositories;
    
    "Enables offline mode that will prevent the module loader from connecting to remote repositories.
     (corresponding command line parameter: `--offline`)"
    shared Boolean offline;
    
    "Specifies a module repository containing dependencies. Can be specified multiple times.
     (default: 'modules'; '~/.ceylon/repo'; http://modules.ceylon-lang.org)
     (corresponding command line parameter: `--rep=<url>`)"
    shared {String*} repositories;
    
    "Specifies the system repository containing essential modules.
     (default: '$CEYLON_HOME/repo')
     (corresponding command line parameter: `--sysrep=<url>`)"
    shared String? systemRepository;
    
    "Specifies the folder to use for caching downloaded modules.
     (default: '~/.ceylon/cache')
     (corresponding command line parameter: `--cacherep=<url>`)"
    shared String? cacheRepository;
    
    "Specifies the fully qualified name of a toplevel method or class with no parameters.
     (corresponding command line parameter: `--run=<toplevel>`)"
    shared String? functionNameToRun;
    
    "Determines if and how compilation should be handled.
     (corresponding command line parameter: `--compile[=<flags>]`)"
    shared CompileOnRun? compileOnRun;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`; `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    shared {RunVerboseMode*}|AllVerboseModes verboseModes;
    
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    shared String? currentWorkingDirectory;
    
    "custom arguments to be added to commandline"
    shared {String*} arguments;
}
