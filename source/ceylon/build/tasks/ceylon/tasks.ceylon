import ceylon.build { Writer }
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

shared Boolean(String[], Writer) compile(
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
    return function(String[] arguments, Writer writer) {
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
            arguments;
        };
        return executeCommand(writer, "compiling", command);
    };
}

shared Boolean(String[], Writer) compileJs(
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
    return function(String[] arguments, Writer writer) {
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
            arguments;
        };
        return executeCommand(writer, "compiling", command);
    };
}

shared Boolean(String[], Writer) doc(
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
    return function(String[] arguments, Writer writer) {
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
            arguments;
        };
        return executeCommand(writer, "documenting", command);
    };
}
shared Boolean(String[], Writer) runModule(
        String moduleName,
        String version = defaultModuleVersion,
        Boolean disableModuleRepository = false,
        Boolean offline = false,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? functionNameToRun = null,
        {RunVerboseMode*} verboseModes = [],
        String ceylon = ceylonExecutable) {
    return function(String[] arguments, Writer writer) {
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
            arguments;
        };
        return executeCommand(writer, "running", command);
    };
}

shared Boolean(String[], Writer) runJsModule(
        String moduleName,
        String version = defaultModuleVersion,
        Boolean offline = false,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? functionNameToRun = null,
        String? debug = null,
        String? pathToNodeJs = null,
        String ceylon = ceylonExecutable) {
    return function(String[] arguments, Writer writer) {
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
            arguments;
        };
        return executeCommand(writer, "running", command);
    };
}

shared Boolean(String[], Writer) compileTests(
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

shared Boolean(String[], Writer) compileJsTests(
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
