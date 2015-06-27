import ceylon.language.meta.declaration { Module }
import ceylon.build.engine {
    GoalDefinitionsBuilder,
    runEngine,
    Status,
    success,
    errorOnTaskExecution,
    dependencyCycleFound,
    noGoalToRun,
    duplicateGoalsFound,
    invalidGoalFound
}
import ceylon.build.task { Writer }
import ceylon.collection { HashMap }

suppressWarnings("expressionTypeNothing")
shared void run() {
    value writer = consoleWriter;
    Options options = commandLineOptions(process.arguments);
    compileModule(options);
    Module? mod = loadModule(options.moduleName, options.moduleVersion);
    if (exists mod) {
        value goals = readAnnotations(mod);
        Integer exitCode;
        switch (goals)
        case (is GoalDefinitionsBuilder) {
            exitCode = start(goals, writer, options.runtime, [*options.goals]);
        } case (is [InvalidGoalDeclaration+]) {
            reportInvalidDeclarations(goals, writer);
            exitCode = 1;
        }
        process.exit(exitCode);
    } else {
        process.writeErrorLine("Build module '``options.moduleName``/``options.moduleVersion``' not found");
        process.exit(exitCodes.buildModuleNotFound);
    }
}

Integer start(GoalDefinitionsBuilder goals, Writer writer, RuntimeOptions options, [String*] arguments) {
    Status status;
    value ceylonBuildArguments = arguments;
    if (options.consoleMode) {
        status = console(goals, writer);
    } else {
        value result = runEngine {
            goals = goals;
            writer = writer;
            arguments =  ceylonBuildArguments;
        };
        status = result.status;
    }
    return statusToExitCode(status);
}

Map<Status, Integer> statusExitCodes = HashMap<Status, Integer> {
    entries = {
        success -> exitCodes.success,
        dependencyCycleFound -> exitCodes.dependencyCycleFound,
        invalidGoalFound -> exitCodes.invalidGoalFound,
        duplicateGoalsFound -> exitCodes.duplicateGoalsFound,
        noGoalToRun -> exitCodes.noGoalToRun,
        errorOnTaskExecution -> exitCodes.errorOnTaskExecution
    };
};

Integer statusToExitCode(Status status) {
    return statusExitCodes[status] else -1;
    
}

void reportInvalidDeclarations([InvalidGoalDeclaration+] invalidDeclarations, Writer writer) {
    writer.error("Invalid goals declarations:");
    for (invalid in invalidDeclarations) {
        writer.error(" - ``unsupportedSignature(invalid)``");
    }
    writer.error(
        """Valid signature for goals function are:
            - `void()`: a simple task that doesn't need access to `Context` object or report failures
            - `Outcome(Context)`: a simple task function
            - `Task()`: A delegate function that returns a task
            - `{Task*}()`: A delegate function that returns a list of tasks""");
}



String unsupportedSignature(InvalidGoalDeclaration invalid) {
    value declaration = invalid.declaration;
    return "Unsupported signature for goal annotated function ```declaration.name```";
}
