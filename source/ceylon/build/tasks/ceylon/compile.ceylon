import ceylon.build.task { context }

"Compiles a Ceylon module using `ceylon compile` tool."
shared void compile(
        "name of modules to compile"
        String|{String*} modules,
        "name of files to compile"
        String|{String*} files = [],
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding = null,
        "Path to source files
         (default: './source')
         (corresponding command line parameter: `--source=<dirs>`)"
        String|{String*} sourceDirectories = [],
        "Path to directory containing resource files
         (default: './resource')
         (corresponding command line parameter: `--resource=<dirs>`)"
        String|{String*} resourceDirectories = [],
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
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {CompileVerboseMode*}|AllVerboseModes verboseModes = [],
        "Ceylon executable that will be used or null to use current ceylon tool"
        String? ceylon = null,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
    ) {
    value modulesList = stringIterable(modules);
    value filesList = stringIterable(files);
    checkCompilationUnits(modulesList, filesList);
    value command = compileCommand {
        CompileArguments {
            modules = modulesList;
            files = filesList;
            encoding = encoding;
            sourceDirectories = stringIterable(sourceDirectories);
            resourceDirectories = stringIterable(resourceDirectories);
            javacOptions = javacOptions;
            outputRepository = outputRepository;
            repositories = stringIterable(repositories);
            systemRepository = systemRepository;
            cacheRepository = cacheRepository;
            user =user;
            password = password;
            offline = offline;
            noDefaultRepositories = noDefaultRepositories;
            systemProperties = systemProperties;
            verboseModes = verboseModes;
            currentWorkingDirectory = currentWorkingDirectory;
        };
    };
    execute(context.writer, "compiling", ceylon, command);
}

"Builds a ceylon compile command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] compileCommand(CompileArguments args) {
    value command = initCommand("compile");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendEncoding(args.encoding));
    command.addAll(appendSourceDirectories(args.sourceDirectories));
    command.addAll(appendResourceDirectories(args.resourceDirectories));
    command.add(appendJavacOptions(args.javacOptions));
    command.add(appendOutputRepository(args.outputRepository));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendUser(args.user));
    command.add(appendPassword(args.password));
    command.add(appendOfflineMode(args.offline));
    command.add(appendNoDefaultRepositories(args.noDefaultRepositories));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendCompilationUnits(args.modules, args.files));
    return cleanCommand(command);
}
