import ceylon.build { Writer }
import ceylon.process { Process, createProcess, currentOutput, currentError }

String defaultModuleVersion = "1.0.0";

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


shared interface VerboseMode of loader | ast | code | cmrloader | benchmark {}
shared object loader satisfies VerboseMode {
    string => "loader";
}
shared object ast satisfies VerboseMode {
    string => "ast";
}
shared object code satisfies VerboseMode {
    string => "code";
}
shared object cmrloader satisfies VerboseMode {
    string => "cmrloader";
}
shared object benchmark satisfies VerboseMode {
    string => "benchmark";
}

shared Boolean(String[], Writer) compile(
        String moduleName,
        String? encoding = null,
        String? sourceDirectories = null,
        String? javacOptions = null,
        String? outputModuleRepository = null,
        String? dependenciesRepository = null,
        String? systemRepository = null,
        String? user = null,
        String? password = null,
        Boolean offline = false,
        Boolean disableModuleRepository = false,
        {VerboseMode*} verboseModes = []
    ) {
    Boolean execute(String[] arguments, Writer writer) {
        StringBuilder sb = StringBuilder();
        sb.append("ceylon compile ");
        sb.append(moduleName);
        if (exists encoding) {
            sb.append(" --encoding=");
            sb.append(encoding);
        }
        if (exists javacOptions) {
            sb.append(" --javac=");
            sb.append(javacOptions);
        }
        if (exists outputModuleRepository) {
            sb.append(" --out=");
            sb.append(outputModuleRepository);
        }
        if (exists dependenciesRepository) {
            sb.append(" --rep=");
            sb.append(dependenciesRepository);
        }
        if (exists sourceDirectories) {
            sb.append(" --src=");
            sb.append(sourceDirectories);
        }
        if (exists systemRepository) {
            sb.append(" --sysrep=");
            sb.append(systemRepository);
        }
        if (exists user) {
            sb.append(" --user=");
            sb.append(user);
        }
        if (exists password) {
            sb.append(" --pass=");
            sb.append(password);
        }
        if (disableModuleRepository) {
            sb.append(" --d");
        }
        if (offline) {
            sb.append(" --offline");
        }
        if (!verboseModes.empty) {
            sb.append(" --verbose=");
            sb.append(",".join({ for (verboseMode in verboseModes) verboseMode.string }));
        }
        if (nonempty arguments) {
            sb.append(" ");
            sb.append(" ".join(arguments));
        }
        return executeCommand(writer, "compiling", sb.string);
    }
    return execute;
}

shared Boolean(String[], Writer) compileJs(String moduleName) {
    return (String[] arguments, Writer writer) =>
        executeCommand(writer, "compiling", "ceylon compile-js ``moduleName``");
}

shared Boolean(String[], Writer) doc(String moduleName) {
    return (String[] arguments, Writer writer) =>
        executeCommand(writer, "documenting", "ceylon doc ``moduleName``");
}

shared Boolean(String[], Writer) runModule(String moduleName, String version = defaultModuleVersion) {
    return (String[] arguments, Writer writer) =>
        executeCommand(writer, "running", "ceylon run ``moduleName``/``version``");
}

shared Boolean(String[], Writer) runJsModule(String moduleName, String version = defaultModuleVersion) {
    return (String[] arguments, Writer writer) =>
        executeCommand(writer, "running", "ceylon run-js ``moduleName``/``version``");
}

shared Boolean(String[], Writer) test(String moduleName, String version = defaultModuleVersion) {
    Boolean execute(String[] arguments, Writer writer) {
        if (!executeCommand(writer, "compiling tests", "ceylon compile ``moduleName`` --src=test-source")) {
            return false;
        }
        return executeCommand(writer, "running tests", "ceylon run ``moduleName``/``version``");
    }
    return execute;
}