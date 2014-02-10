import ceylon.collection { HashMap }
import ceylon.build.engine {
    GoalDefinitionsBuilder,
    runEngine,
    reportInvalidDefinitions, Status, success, noGoalToRun, errorOnTaskExecution, duplicateGoalsFound, invalidGoalFound, dependencyCycleFound
}
import ceylon.build.task { Writer }

"Returns `true` if `--console` option is found in `arguments`."
Boolean interactive([String*] arguments) {
    return arguments.contains("--console");
}

"An interactive console."
Status console(GoalDefinitionsBuilder goals, Writer writer) {
    value definitionValidationResult = goals.validate();
    if (!definitionValidationResult.valid) {
        return reportInvalidDefinitions(definitionValidationResult, writer);
    } else {
        assert(exists definitions = definitionValidationResult.definitions);
        print("Available goals: ``definitions.availableGoals``");
        print("Enter Ctrl + D to quit");
        while (true) {
            process.write("> ");
            String? rawLine = process.readLine();
            if (is Null rawLine) {
                process.writeLine();
                return success;
            }
            assert(exists rawLine);
            String line = rawLine.trimmed;
            value result = runEngine(definitions, writer, line.split().sequence);
            print(statusToMessage(result.status));
        }
    }
}

Map<Status, String> statusMessages = HashMap<Status, String> {
    entries = {
        success -> "Success",
        dependencyCycleFound -> "Dependency Cycle Found",
        invalidGoalFound -> "Invalid goal found",
        duplicateGoalsFound -> "Duplicate goals found",
        noGoalToRun -> "No goal to run",
        errorOnTaskExecution -> "Error on task execution"
    };
};

String statusToMessage(Status status) {
    assert(exists msg = statusMessages[status]);
    return msg;
}
