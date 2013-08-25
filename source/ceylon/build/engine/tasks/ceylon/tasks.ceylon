import ceylon.build.task { Context, TaskDefinition, Writer }
import ceylon.process { Process, createProcess, currentOutput, currentError }

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
        return executeCommand(context.writer, "compiling", command);
    };
}

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
        return executeCommand(context.writer, "compiling", command);
    };
}

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
        return executeCommand(context.writer, "documenting", command);
    };
}
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
        return executeCommand(context.writer, "running", command);
    };
}

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
        return executeCommand(context.writer, "running", command);
    };
}

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

Boolean executeCommand(Writer writer, String title, String cmd) {
    value commandToExecute = cmd.trimmed;
    writer.info("``title``: '``commandToExecute``'");
    Process process = createProcess {
        command = commandToExecute;
        output = currentOutput;
        error = currentError;
    };
    process.waitForExit();
    if (exists exitCode = process.exitCode) {
        return exitCode == 0;
    }
    return false;
}
