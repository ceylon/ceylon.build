import ceylon.build.task { Task }
import ceylon.build.tasks.ceylon { compile, CompileVerboseMode }

"""Compiles a Ceylon test module using `ceylon compile` tool.
   
   `--source` command line parameter is set to `"test-source"`"""
shared Task compileTests(
        "name of modules to compile"
        String|{String*} modules,
        "name of files to compile"
        String|{String*} files = [],
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding = null,
        "Passes an option to the underlying java compiler
         (corresponding command line parameter: `--javac=<option>`)"
        String? javacOptions = null,
        "Specifies the output module repository (which must be publishable).
         (default: './modules')
         (corresponding command line parameter: `--out=<url>`)"
        String? outputRepository = null,
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
        "Sets the user name for use with an authenticated output repository
         (corresponding command line parameter: `--user=<name>`)"
        String? user = null,
        "Sets the password for use with an authenticated output repository
         (corresponding command line parameter: `--pass=<secret>`)"
        String? password = null,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline = false,
        "Indicates that the default repositories should not be used
         (corresponding command line parameter: `--no-default-repositories`)"
        Boolean noDefaultRepositories = false,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties = [],
        "Produce verbose output. If no 'flags' are given then be verbose about everything,
         otherwise just be vebose about the flags which are present
         (corresponding command line parameter: `--verbose=<flags>`)"
        {CompileVerboseMode*} verboseModes = [],
        "Ceylon executable that will be used or null to use current ceylon tool"
        String? ceylon = null,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
) {
    return compile {
        modules = modules;
        files = files;
        encoding = encoding;
        sourceDirectories = testSourceDirectory;
        resourceDirectories = testResourceDirectory;
        javacOptions = javacOptions;
        outputRepository = outputRepository;
        repositories = repositories;
        systemRepository = systemRepository;
        cacheRepository = cacheRepository;
        user = user;
        password = password;
        offline = offline;
        noDefaultRepositories = noDefaultRepositories;
        systemProperties = systemProperties;
        verboseModes = verboseModes;
        ceylon = ceylon;
        currentWorkingDirectory = currentWorkingDirectory;
    };
}
