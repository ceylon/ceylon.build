import ceylon.build.task { Context, TaskDefinition, Writer }
import ceylon.process { Process, createProcess, currentOutput, currentError }
import ceylon.build.tasks.commandline { executeCommand }

String ceylonExecutable = "ceylon";
String defaultModuleVersion = "1.0.0";
[String+] testSourceDirectory = ["test-source"];

shared interface CompileVerboseMode of loader | ast | code | cmrloader | benchmark {}
shared object loader satisfies CompileVerboseMode {
    string => "loader";
}
shared object ast satisfies CompileVerboseMode {
    string => "ast";
}
shared object code satisfies CompileVerboseMode {
    string => "code";
}
shared object cmrloader satisfies CompileVerboseMode {
    string => "cmrloader";
}
shared object benchmark satisfies CompileVerboseMode {
    string => "benchmark";
}

shared interface RunVerboseMode of cmr {}
shared object cmr satisfies RunVerboseMode {
    string => "cmr";
}

"""Compiles a Ceylon module using `ceylon compile` command line.
   
   Function parameter --> Ceylon command parameter correspondence
   * `encoding` --> `--encoding`
   * `sourceDirectories` --> `--src`
   * `javacOptions` --> `--javac`
   * `outputModuleRepository` --> `--out`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `user` --> `--user`
   * `password` --> `--pass`
   * `offline` --> `--offline`
   * `disableModuleRepository` --> `--d`
   * `verboseModes` --> `--verbose`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition compile(
        String moduleName,
        String? encoding = "",
        {String*} sourceDirectories = [],
        String? javacOptions = null,
        String? outputModuleRepository = null,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? user = null,
        String? password = null,
        Boolean offline = false,
        Boolean disableModuleRepository = false,
        {CompileVerboseMode*} verboseModes = [],
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

"""Compiles a Ceylon module to javascript using `ceylon compile-js` command line.
   
   Function parameter --> Ceylon command parameter correspondence
   * `encoding` --> `--encoding`
   * `sourceDirectories` --> `--src`
   * `outputModuleRepository` --> `--out`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `user` --> `--user`
   * `password` --> `--pass`
   * `offline` --> `--offline`
   * `noComments` --> `--no-comments`
   * `noIndent` --> `--no-indent`
   * `noModule` --> `--no-module`
   * `optimize` --> `--optimize`
   * `profile` --> `--profile`
   * `skipSourceArchive` --> `--skip-src-archive`
   * `verbose` --> `--verbose`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition compileJs(
        String moduleName,
        String? encoding = null,
        {String*} sourceDirectories = [],
        String? outputModuleRepository = null,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? user = null,
        String? password = null,
        Boolean offline = false,
        Boolean compact = false,
        Boolean noComments = false,
        Boolean noIndent = false,
        Boolean noModule = false,
        Boolean optimize = false,
        Boolean profile = false,
        Boolean skipSourceArchive = false,
        Boolean verbose = false,
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


"""Documents a Ceylon module using `ceylon doc` command line.
   
   Function parameter --> Ceylon command parameter correspondence
   * `encoding` --> `--encoding`
   * `sourceDirectories` --> `--src`
   * `outputModuleRepository` --> `--out`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `user` --> `--user`
   * `password` --> `--pass`
   * `offline` --> `--offline`
   * `link` --> `--link`
   * `includeNonShared` --> `--non-shared`
   * `includeSourceCode` --> `--source-code`
   * `verboseModes` --> `--verbose`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition doc(
        String moduleName,
        String? encoding = null,
        {String*} sourceDirectories = [],
        String? outputModuleRepository = null,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? user = null,
        String? password = null,
        Boolean offline = false,
        String? link = null,
        Boolean includeNonShared = false,
        Boolean includeSourceCode = false,
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

"""Runs a Ceylon module using `ceylon run` command line.
   
   Function parameter --> Ceylon command parameter correspondence
   * `disableModuleRepository` --> `--d`
   * `offline` --> `--offline`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `functionNameToRun` --> `--run`
   * `verboseModes` --> `--verbose`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition runModule(
        String moduleName,
        String version = defaultModuleVersion,
        Boolean disableModuleRepository = false,
        Boolean offline = false,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? functionNameToRun = null,
        {RunVerboseMode*} verboseModes = [],
        String ceylon = ceylonExecutable) {
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

"""Runs a Ceylon module on node.js using `ceylon run-js` command line.
   
   Function parameter --> Ceylon command parameter correspondence
   * `offline` --> `--offline`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `functionNameToRun` --> `--run`
   * `debug` --> `--debug`
   * `pathToNodeJs` --> `--node-exe`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition runJsModule(
        String moduleName,
        String version = defaultModuleVersion,
        Boolean offline = false,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? functionNameToRun = null,
        String? debug = null,
        String? pathToNodeJs = null,
        String ceylon = ceylonExecutable) {
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
   
   Function parameter --> Ceylon command parameter correspondence
   * `encoding` --> `--encoding`
   * `sourceDirectories` --> `--src`
   * `javacOptions` --> `--javac`
   * `outputModuleRepository` --> `--out`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `user` --> `--user`
   * `password` --> `--pass`
   * `offline` --> `--offline`
   * `disableModuleRepository` --> `--d`
   * `verboseModes` --> `--verbose`
   
   `--src` command line parameter is set to `"test-source"`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition compileTests(
        String moduleName,
        String? encoding = "",
        String? javacOptions = null,
        String? outputModuleRepository = null,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? user = null,
        String? password = null,
        Boolean offline = false,
        Boolean disableModuleRepository = false,
        {CompileVerboseMode*} verboseModes = [],
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
   
   Function parameter --> Ceylon command parameter correspondence
   * `encoding` --> `--encoding`
   * `sourceDirectories` --> `--src`
   * `outputModuleRepository` --> `--out`
   * `dependenciesRepository` --> `--rep`
   * `systemRepository` --> `--sysrep`
   * `user` --> `--user`
   * `password` --> `--pass`
   * `offline` --> `--offline`
   * `noComments` --> `--no-comments`
   * `noIndent` --> `--no-indent`
   * `noModule` --> `--no-module`
   * `optimize` --> `--optimize`
   * `profile` --> `--profile`
   * `skipSourceArchive` --> `--skip-src-archive`
   * `verbose` --> `--verbose`
   
   `--src` command line parameter is set to `"test-source"`
   
   `ceylon` ceylon executable that will be used.
   """
shared TaskDefinition compileJsTests(
        String moduleName,
        String? encoding = null,
        String? outputModuleRepository = null,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? user = null,
        String? password = null,
        Boolean offline = false,
        Boolean compact = false,
        Boolean noComments = false,
        Boolean noIndent = false,
        Boolean noModule = false,
        Boolean optimize = false,
        Boolean profile = false,
        Boolean skipSourceArchive = false,
        Boolean verbose = false,
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
