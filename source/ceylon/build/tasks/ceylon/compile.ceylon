import ceylon.build.task { Task, Context }

"Compiles a Ceylon module using `ceylon compile` command line."
shared Task compile(
        doc("name of modules to compile")
        String|{String*} modules,
        doc("name of files to compile")
        String|{String*} files = [],
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = "",
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--source=<dirs>`)")
        String|{String*} sourceDirectories = [],
        doc("Path to directory containing resource files
             (default: './resource')
             (corresponding command line parameter: `--resource=<dirs>`)")
        String|{String*} resourceDirectories = [],
        doc("Passes an option to the underlying java compiler
             (corresponding command line parameter: `--javac=<option>`)")
        String? javacOptions = null,
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String|{String*} repositories = [],
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Specifies the folder to use for caching downloaded modules.
             (default: '~/.ceylon/cache')
             (corresponding command line parameter: `--cacherep=<url>`)")
        String? cacheRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Indicates that the default repositories should not be used
             (corresponding command line parameter: `--no-default-repositories`)")
        Boolean noDefaultRepositories = false,
        doc("Produce verbose output.
             (corresponding command line parameter: `--verbose=<flags>`)")
        {CompileVerboseMode*}|AllVerboseModes verboseModes = [],
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable,
        doc("Specifies the current working directory for this tool.
             (default: the directory where the tool is run from)
             (corresponding command line parameter: `--cwd=<dir>`)")
        String? currentWorkingDirectory = null
    ) {
    value modulesList = stringIterable(modules);
    value filesList = stringIterable(files);
    checkCompilationUnits(modulesList, filesList);
    return function(Context context) {
        value command = buildCompileCommand {
            ceylon;
            currentWorkingDirectory;
            modulesList;
            filesList;
            encoding;
            stringIterable(sourceDirectories);
            stringIterable(resourceDirectories);
            javacOptions;
            outputRepository;
            stringIterable(repositories);
            systemRepository;
            cacheRepository;
            user;
            password;
            offline;
            noDefaultRepositories;
            verboseModes;
            context.arguments;
        };
        return execute(context.writer, "compiling", command);
    };
}

"Compiles a Ceylon module to javascript using `ceylon compile-js` command line."
shared Task compileJs(
        doc("name of modules to compile")
        String|{String*} modules,
        doc("name of files to compile")
        String|{String*} files = [],
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = null,
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--source=<dirs>`)")
        String|{String*} sourceDirectories = [],
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String|{String*} repositories = [],
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Specifies the folder to use for caching downloaded modules.
             (default: '~/.ceylon/cache')
             (corresponding command line parameter: `--cacherep=<url>`)")
        String? cacheRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Equivalent to '--no-indent' '--no-comments'
             (corresponding command line parameter: `--compact`)")
        Boolean compact = false,
        doc("Do NOT generate any comments
             (corresponding command line parameter: `--no-comments`)")
        Boolean noComments = false,
        doc("Do NOT indent code
             (corresponding command line parameter: `--no-indent`)")
        Boolean noIndent = false,
        doc("Do NOT wrap generated code as CommonJS module
             (corresponding command line parameter: `--no-module`)")
        Boolean noModule = false,
        doc("Create prototype-style JS code
             (corresponding command line parameter: `--optimize`)")
        Boolean optimize = false,
        doc("Time the compilation phases (results are printed to standard error)
             (corresponding command line parameter: `--offline`)")
        Boolean profile = false,
        doc("Do NOT generate .src archive - useful when doing joint compilation
             (corresponding command line parameter: `--skip-src-archive`)")
        Boolean skipSourceArchive = false,
        doc("Print messages while compiling
             (corresponding command line parameter: `--verbose`)")
        Boolean verbose = false,
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable,
        doc("Specifies the current working directory for this tool.
             (default: the directory where the tool is run from)
             (corresponding command line parameter: `--cwd=<dir>`)")
        String? currentWorkingDirectory = null
    ) {
    value modulesList = stringIterable(modules);
    value filesList = stringIterable(files);
    checkCompilationUnits(modulesList, filesList);
    return function(Context context) {
        value command = buildCompileJsCommand {
            ceylon;
            currentWorkingDirectory;
            modulesList;
            filesList;
            encoding;
            stringIterable(sourceDirectories);
            outputRepository;
            stringIterable(repositories);
            systemRepository;
            cacheRepository;
            user;
            password;
            offline;
            compact;
            noComments;
            noIndent;
            noModule;
            optimize;
            profile;
            skipSourceArchive;
            verbose;
            context.arguments;
        };
        return execute(context.writer, "compiling", command);
    };
}

void checkCompilationUnits({String*} modules, {String*} files) {
    value compilationUnits = concatenate(modules, files).sequence;
    "Modules and/or files to compile must be provided"
    assert (nonempty compilationUnits);
}

{String+} multipleStringsIterable(String|{String+} stringOrMultipleStrings) {
    {String+} stringIterable;
    switch(stringOrMultipleStrings)
    case (is String) {
        stringIterable = {stringOrMultipleStrings};
    }
    case (is {String+}) {
        stringIterable = stringOrMultipleStrings;
    }
    return stringIterable;
}


{String*} stringIterable(String|{String*} stringOrStrings) {
    {String*} stringIterable;
    switch(stringOrStrings)
    case (is String) {
        stringIterable = {stringOrStrings};
    }
    case (is {String*}) {
        stringIterable = stringOrStrings;
    }
    return stringIterable;
}
