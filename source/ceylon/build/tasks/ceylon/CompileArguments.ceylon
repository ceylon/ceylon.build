"Holds arguments to be passed to ceylon compile tool."
shared class CompileArguments(
    modules,
    files = [],
    encoding = null,
    sourceDirectories = [],
    resourceDirectories = [],
    javacOptions = null,
    outputRepository = null,
    repositories = [],
    systemRepository = null,
    cacheRepository = null,
    user = null,
    password = null,
    offline = false,
    noDefaultRepositories = false,
    systemProperties = [],
    verboseModes = [],
    currentWorkingDirectory = null,
    arguments = []) {
    
    "name of modules to compile"
    shared {String*} modules;
    
    "name of files to compile"
    shared {String*} files;
    
    "encoding used for reading source files
     (default: platform-specific)
     (corresponding command line parameter: `--encoding=<encoding>`)"
    shared String? encoding;
    
    "Path to source files
     (default: './source')
     (corresponding command line parameter: `--source=<dirs>`)"
    shared {String*} sourceDirectories;
    
    "Path to directory containing resource files
     (default: './resource')
     (corresponding command line parameter: `--resource=<dirs>`)"
    shared {String*} resourceDirectories;
    
    "Passes an option to the underlying java compiler
     (corresponding command line parameter: `--javac=<option>`)"
    shared String? javacOptions;
    
    "Specifies the output module repository (which must be publishable).
     (default: './modules')
     (corresponding command line parameter: `--out=<url>`)"
    shared String? outputRepository;
    
    "Specifies a module repository containing dependencies. Can be specified multiple times.
     (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
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
    
    "Sets the user name for use with an authenticated output repository
     (corresponding command line parameter: `--user=<name>`)"
    shared String? user;
    
    "Sets the password for use with an authenticated output repository
     (corresponding command line parameter: `--pass=<secret>`)"
    shared String? password;
    
    "Enables offline mode that will prevent the module loader from connecting to remote repositories.
     (corresponding command line parameter: `--offline`)"
    shared Boolean offline;
    
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared Boolean noDefaultRepositories;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared {CompileVerboseMode*}|AllVerboseModes verboseModes;
    
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    shared String? currentWorkingDirectory;
    
    "custom arguments to be added to commandline"
    shared {String*} arguments;
}
