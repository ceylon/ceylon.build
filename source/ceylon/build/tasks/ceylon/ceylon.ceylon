import ceylon.build.task { context }

shared object ceylon {
    
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
    
    "Compiles a Ceylon module to javascript using `ceylon compile-js` tool."
    shared void compileJs(
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
        "Equivalent to '--no-indent' '--no-comments'
         (corresponding command line parameter: `--compact`)"
        Boolean compact = false,
        "Create lexical scope-style JS code
         (corresponding command line parameter: `--lexical-scope-style`)"
        Boolean lexicalScopeStyle = false,
        "Do NOT generate any comments
         (corresponding command line parameter: `--no-comments`)"
        Boolean noComments = false,
        "Do NOT indent code
         (corresponding command line parameter: `--no-indent`)"
        Boolean noIndent = false,
        "Do NOT wrap generated code as CommonJS module
         (corresponding command line parameter: `--no-module`)"
        Boolean noModule = false,
        "Create prototype-style JS code
         (corresponding command line parameter: `--optimize`)"
        Boolean optimize = false,
        "Time the compilation phases (results are printed to standard error)
         (corresponding command line parameter: `--profile`)"
        Boolean profile = false,
        "Do NOT generate .src archive - useful when doing joint compilation
         (corresponding command line parameter: `--skip-src-archive`)"
        Boolean skipSourceArchive = false,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties = [],
        "Produce verbose output.
         (corresponding command line parameter: `--verbose[=<flags>]`)"
        {CompileJsVerboseMode*}|AllVerboseModes verboseModes = [],
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
        value command = compileJsCommand {
            CompileJsArguments {
                modules = modulesList;
                files = filesList;
                encoding = encoding;
                sourceDirectories = stringIterable(sourceDirectories);
                outputRepository = outputRepository;
                repositories = stringIterable(repositories);
                systemRepository = systemRepository;
                cacheRepository = cacheRepository;
                user = user;
                password = password;
                offline = offline;
                compact = compact;
                lexicalScopeStyle = lexicalScopeStyle;
                noComments = noComments;
                noIndent = noIndent;
                noModule = noModule;
                optimize = optimize;
                profile = profile;
                skipSourceArchive = skipSourceArchive;
                systemProperties = systemProperties;
                verboseModes = verboseModes;
                currentWorkingDirectory = currentWorkingDirectory;
            };
        };
        execute(context.writer, "compiling", ceylon, command);
    }
    
    """Compiles a Ceylon test module using `ceylon compile` tool.
       
       `--source` command line parameter is set to `"test-source"`"""
    shared void compileTests(
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
        compile {
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

    """Compiles a Ceylon test module to javascript using `ceylon compile-js` tool.
       
       `--source` command line parameter is set to `"test-source"`"""
    shared void compileJsTests(
        "name of modules to compile"
        String|{String*} modules,
        "name of files to compile"
        String|{String*} files = [],
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding = null,
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
        "Equivalent to '--no-indent' '--no-comments'
         (corresponding command line parameter: `--compact`)"
        Boolean compact = false,
        "Create lexical scope-style JS code
         (corresponding command line parameter: `--lexical-scope-style`)"
        Boolean lexicalScopeStyle = false,
        "Do NOT generate any comments
         (corresponding command line parameter: `--no-comments`)"
        Boolean noComments = false,
        "Do NOT indent code
         (corresponding command line parameter: `--no-indent`)"
        Boolean noIndent = false,
        "Do NOT wrap generated code as CommonJS module
         (corresponding command line parameter: `--no-module`)"
        Boolean noModule = false,
        "Create prototype-style JS code
         (corresponding command line parameter: `--optimize`)"
        Boolean optimize = false,
        "Time the compilation phases (results are printed to standard error)
         (corresponding command line parameter: `--offline`)"
        Boolean profile = false,
        "Do NOT generate .src archive - useful when doing joint compilation
         (corresponding command line parameter: `--skip-src-archive`)"
        Boolean skipSourceArchive = false,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties = [],
        "Produce verbose output. If no 'flags' are given then be verbose about everything,
         otherwise just be vebose about the flags which are present
         (corresponding command line parameter: `--verbose=<flags>`)"
        {CompileJsVerboseMode*} verboseModes = [],
        "Ceylon executable that will be used or null to use current ceylon tool"
        String? ceylon = null,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
    ) {
        compileJs {
            modules = modules;
            files = files;
            encoding = encoding;
            sourceDirectories = testSourceDirectory;
            outputRepository = outputRepository;
            repositories = repositories;
            systemRepository = systemRepository;
            cacheRepository = cacheRepository;
            user =user;
            password = password;
            offline = offline;
            compact = compact;
            lexicalScopeStyle = lexicalScopeStyle;
            noComments = noComments;
            noIndent = noIndent;
            noModule = noModule;
            optimize = optimize;
            profile = profile;
            skipSourceArchive = skipSourceArchive;
            systemProperties = systemProperties;
            verboseModes = verboseModes;
            ceylon = ceylon;
            currentWorkingDirectory = currentWorkingDirectory;
        };
    }
    
    "Documents a Ceylon module using `ceylon doc` tool."
    shared void document(
        "list of modules to document"
        String|{String*}  modules,
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding = null,
        "Path to source files
         (default: './source')
         (corresponding command line parameter: `--source=<dirs>`)"
        String|{String*} sourceDirectories = [],
        "A directory containing your module documentation
         (default: './doc')
         (corresponding command line parameter: `--doc=<dirs>`)"
        String? documentationDirectory = null,
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
        // TODO add support for --nomtimecheck
        // TODO need to improve link type to support pattern => url
        "The URL of a module repository containing documentation for external dependencies.
         
         Parameter url must be one of supported protocols (http://, https:// or file://).
         Parameter url can be prefixed with module name pattern, separated by a '=' character,
         determine for which external modules will be use.
         
         Examples:
         
         - --link https://modules.ceylon-lang.org/
         - --link ceylon.math=https://modules.ceylon-lang.org/
             
         (corresponding command line parameter: `--link=<url>`)"
        String? link = null,
        "Includes documentation for package-private declarations.
         (corresponding command line parameter: `--non-shared`)"
        Boolean includeNonShared = false,
        "Includes source code in the generated documentation.
         (corresponding command line parameter: `--source-code`)"
        Boolean includeSourceCode = false,
        "Do not print warnings about broken links.
         (corresponding command line parameter: `--ignore-broken-link`)"
        Boolean ignoreBrokenLink = false,
        "Do not print warnings about missing documentation.
         (corresponding command line parameter: `--ignore-missing-doc`)"
        Boolean ignoreMissingDoc = false,
        "Do not print warnings about missing throws annotation.
         (corresponding command line parameter: `--ignore-missing-throws`)"
        Boolean ignoreMissingThrows = false,
        "Sets the header text to be placed at the top of each page.
         (corresponding command line parameter: `--header=<header>`)"
        String? header = null,
        "Sets the footer text to be placed at the bottom of each page.
         (corresponding command line parameter: `--footer=<footer>`)"
        String? footer = null,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties = [],
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {DocVerboseMode*}|AllVerboseModes verboseModes = [],
        "Ceylon executable that will be used or null to use current ceylon tool"
        String? ceylon = null,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
    ) {
        value command = docCommand {
            DocArguments {
                modules = stringIterable(modules);
                encoding = encoding;
                sourceDirectories = stringIterable(sourceDirectories);
                documentationDirectory = documentationDirectory;
                outputRepository = outputRepository;
                repositories = stringIterable(repositories);
                systemRepository = systemRepository;
                cacheRepository = cacheRepository;
                user = user;
                password = password;
                offline = offline;
                link = link;
                includeNonShared = includeNonShared;
                includeSourceCode = includeSourceCode;
                ignoreBrokenLink = ignoreBrokenLink;
                ignoreMissingDoc = ignoreMissingDoc;
                ignoreMissingThrows = ignoreMissingThrows;
                header = header;
                footer = footer;
                systemProperties = systemProperties;
                verboseModes = verboseModes;
                currentWorkingDirectory = currentWorkingDirectory;
            };
        };
        execute(context.writer, "documenting", ceylon, command);
    }
    
    "Runs a Ceylon module using `ceylon run` tool."
    shared void run(
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
            };
        };
        execute(context.writer, "running", ceylon, command);
    }

    "Runs a Ceylon module on node.js using `ceylon run-js` tool."
    shared void runJs(
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
        value command = runJsCommand {
            RunJsArguments {
                moduleName = moduleName;
                version = version;
                moduleArguments = moduleArguments;
                noDefaultRepositories = true;
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
                currentWorkingDirectory = currentWorkingDirectory;
            };
        };
        execute(context.writer, "running", ceylon, command);
    }
    
    "Runs tests of Ceylon module using `ceylon test` tool."
    shared void test(
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
        value command = testCommand {
            TestArguments {
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
                currentWorkingDirectory = currentWorkingDirectory;
            };
        };
        execute(context.writer, "testing", ceylon, command);
    }
}