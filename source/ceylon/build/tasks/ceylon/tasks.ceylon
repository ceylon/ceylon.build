import ceylon.build.task { Context, TaskDefinition, Writer }
import ceylon.build.tasks.commandline { executeCommand }

String ceylonExecutable = "ceylon";
String defaultModuleVersion = "1.0.0";
[String+] testSourceDirectory = ["test-source"];

shared interface VerboseMode {}
shared object all satisfies VerboseMode {}

doc("Verbose modes for jvm backend compilation")
shared interface CompileVerboseMode of loader | ast | code | cmrloader | benchmark {}

doc("verbose mode: loader")
shared object loader satisfies CompileVerboseMode { string => "loader"; }
doc("verbose mode: ast")
shared object ast satisfies CompileVerboseMode { string => "ast"; }
doc("verbose mode: code")
shared object code satisfies CompileVerboseMode { string => "code"; }
doc("verbose mode: cmrloader")
shared object cmrloader satisfies CompileVerboseMode { string => "cmrloader"; }
doc("verbose mode: benchmark")
shared object benchmark satisfies CompileVerboseMode { string => "benchmark"; }

doc("Verbose modes for jvm backend execution")
shared interface RunVerboseMode of cmr {}
shared object cmr satisfies RunVerboseMode { string => "cmr"; }

"Compiles a Ceylon module using `ceylon compile` command line."
shared TaskDefinition compile(
        doc("name of module to compile")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = "",
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--src=<dirs>`)")
        {String*} sourceDirectories = [],
        doc("Passes an option to the underlying java compiler
             (corresponding command line parameter: `--javac=<option>`)")
        String? javacOptions = null,
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Disables the default module repositories and source directory.
             (corresponding command line parameter: `--d`)")
        Boolean disableModuleRepository = false,
        doc("Produce verbose output.
             (corresponding command line parameter: `--verbose=<flags>`)")
        {CompileVerboseMode*}|VerboseMode verboseModes = [],
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildCompileCommand {
            ceylon;
            moduleName;
            encoding;
            sourceDirectories;
            javacOptions;
            outputModuleRepository;
            dependenciesRepository;
            systemRepository;
            user;
            password;
            offline;
            disableModuleRepository;
            verboseModes;
            context.arguments;
        };
        return execute(context.writer, "compiling", command);
    };
}

"Compiles a Ceylon module to javascript using `ceylon compile-js` command line."
shared TaskDefinition compileJs(
        doc("name of module to compile")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = null,
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--src=<dirs>`)")
        {String*} sourceDirectories = [],
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
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
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildCompileJsCommand {
            ceylon;
            moduleName;
            encoding;
            sourceDirectories;
            outputModuleRepository;
            dependenciesRepository;
            systemRepository;
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


"Documents a Ceylon module using `ceylon doc` command line."
shared TaskDefinition document(
        doc("name of module to document")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = "",
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--src=<dirs>`)")
        {String*} sourceDirectories = [],
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("""The URL of a module repository containing documentation for external dependencies.

               Parameter url must be one of supported protocols (http://, https:// or file://).
               Parameter url can be prefixed with module name pattern, separated by a '=' character,
               determine for which external modules will be use.

               Examples:

               --link https://modules.ceylon-lang.org/
               --link ceylon.math=https://modules.ceylon-lang.org/
             
                (corresponding command line parameter: `--link=<url>`)""")
        String? link = null,
        doc("Includes documentation for package-private declarations.
             (corresponding command line parameter: `--non-shared`)")
        Boolean includeNonShared = false,
        doc("Includes source code in the generated documentation.
             (corresponding command line parameter: `--source-code`)")
        Boolean includeSourceCode = false,
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildDocCommand {
            ceylon;
            moduleName;
            encoding;
            sourceDirectories;
            outputModuleRepository;
            dependenciesRepository;
            systemRepository;
            user;
            password;
            offline;
            link;
            includeNonShared;
            includeSourceCode;
            context.arguments;
        };
        return execute(context.writer, "documenting", command);
    };
}

"Runs a Ceylon module using `ceylon run` command line."
shared TaskDefinition runModule(
        doc("name of module to run")
        String moduleName,
        doc("version of module to run")
        String version = defaultModuleVersion,
        doc("Disables the default module repositories and source directory.
             (corresponding command line parameter: `--d`)")
        Boolean disableModuleRepository = false,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Specifies the fully qualified name of a toplevel method or class with no parameters.
             (corresponding command line parameter: `--run=<toplevel>`)")
        String? functionNameToRun = null,
        doc("Produce verbose output.
             (corresponding command line parameter: `--verbose=<flags>`)")
        {RunVerboseMode*}|VerboseMode verboseModes = [],
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildRunCommand {
            ceylon;
            moduleName;
            version;
            disableModuleRepository;
            offline;
            dependenciesRepository;
            systemRepository;
            functionNameToRun;
            verboseModes;
            context.arguments;
        };
        return execute(context.writer, "running", command);
    };
}

"Runs a Ceylon module on node.js using `ceylon run-js` command line"
shared TaskDefinition runJsModule(
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
        String? dependenciesRepository = null,
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
            dependenciesRepository;
            systemRepository;
            functionNameToRun;
            debug;
            pathToNodeJs;
            context.arguments;
        };
        return execute(context.writer, "running", command);
    };
}

"""Compiles a Ceylon test module using `ceylon compile` command line.
   
   `--src` command line parameter is set to `"test-source"`"""
shared TaskDefinition compileTests(
        doc("name of module to compile")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = "",
        doc("Passes an option to the underlying java compiler
             (corresponding command line parameter: `--javac=<option>`)")
        String? javacOptions = null,
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Disables the default module repositories and source directory.
             (corresponding command line parameter: `--d`)")
        Boolean disableModuleRepository = false,
        doc("Produce verbose output. If no 'flags' are given then be verbose about everything,
             otherwise just be vebose about the flags which are present
             (corresponding command line parameter: `--verbose=<flags>`)")
        {CompileVerboseMode*} verboseModes = [],
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return compile {
        moduleName;
        encoding;
        testSourceDirectory;
        javacOptions;
        outputModuleRepository;
        dependenciesRepository;
        systemRepository;
        user;
        password;
        offline;
        disableModuleRepository;
        verboseModes;
        ceylon;
    };
}

"""Compiles a Ceylon test module to javascript using `ceylon compile-js` command line.
   
   `--src` command line parameter is set to `"test-source"`"""
shared TaskDefinition compileJsTests(
        doc("name of module to compile")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = null,
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
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
        String ceylon = ceylonExecutable
) {
    return compileJs {
        moduleName;
        encoding;
        testSourceDirectory;
        outputModuleRepository;
        dependenciesRepository;
        systemRepository;
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
        ceylon;
    };
}

Boolean execute(Writer writer, String title, String command) {
    value commandToExecute = command.trimmed;
    writer.info("``title``: '``commandToExecute``'");
    Integer? exitCode = executeCommand(commandToExecute);
    return (exitCode else 0) == 0;
}
