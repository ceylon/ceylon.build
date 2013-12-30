import ceylon.collection { HashMap }
import ceylon.build.engine {
    GoalDefinitionsBuilder,
    runEngineFromDefinitions,
    consoleWriter,
    exitCodes,
    reportInvalidDefinitions
}

"Returns `true` if `--console` option is found in `arguments`."
Boolean interactive([String*] arguments) {
    return arguments.contains("--console");
}

"An interactive console."
Integer console(GoalDefinitionsBuilder goals) {
    value exitMessages = HashMap<Integer, String>({
        exitCodes.success->"Success",
        exitCodes.dependencyCycleFound->"Dependency Cycle Found",
        exitCodes.invalidGoalFound->"Invalid goal found",
        exitCodes.duplicateGoalsFound->"Duplicate goals found",
        exitCodes.noGoalToRun->"No goal to run",
        exitCodes.errorOnTaskExecution->"Error on task execution"
    });
    value definitionValidationResult = goals.validate();
    if (!definitionValidationResult.valid) {
        return reportInvalidDefinitions(definitionValidationResult, consoleWriter);
    } else {
        assert(exists definitions = definitionValidationResult.definitions);
        print("Available goals: ``definitions.availableGoals``");
        print("Enter Ctrl + D to quit");
        while (true) {
            process.write("> ");
            String? rawLine = process.readLine();
            if (is Null rawLine) {
                process.writeLine();
                return exitCodes.success;
            }
            assert(exists rawLine);
            String line = rawLine.trimmed;
            value result = runEngineFromDefinitions(definitions, "", line.split().sequence, consoleWriter);
            assert(exists msg = exitMessages[result.exitCode]);
            print(msg);
        }
    }
}
