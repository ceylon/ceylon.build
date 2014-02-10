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

shared void run() {
    value writer = consoleWriter;
    value arguments = process.arguments;
    "module should be provided"
    assert(exists name = arguments[0]);
    Module? mod = loadModule(name);
    if (exists mod) {
        value goals = readAnnotations(mod);
        Integer exitCode;
        switch (goals)
        case (is GoalDefinitionsBuilder){
            exitCode = start(goals, writer, arguments);
        } case (is [InvalidGoalDeclaration+]) {
            reportInvalidDeclarations(goals, writer);
            exitCode = 1;
        }
        process.exit(exitCode);
    } else {
        process.writeErrorLine("Module '``name``' not found");
        process.exit(1);
    }
}

Integer start(GoalDefinitionsBuilder goals, Writer writer, [String*] arguments) {
    Status status;
    value ceylonBuildArguments = arguments[1...];
    if (interactive(ceylonBuildArguments)) {
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
