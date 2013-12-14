import ceylon.build.task { Goal, GoalSet }
import ceylon.collection { HashMap }

"Returns `true` if `--console` option is found in `arguments`."
Boolean interactive([String*] arguments) {
    return arguments.contains("--console");
}

"An interactive console."
void console({<Goal|GoalSet>+} goals) {
    value exitMessages = HashMap<Integer, String>({
        exitCodes.success->"Success",
        exitCodes.dependencyCycleFound->"Dependency Cycle Found",
        exitCodes.invalidGoalFound->"Invalid goal found",
        exitCodes.duplicateGoalsFound->"Duplicate goals found",
        exitCodes.noGoalToRun->"No goal to run",
        exitCodes.errorOnTaskExecution->"Error on task execution"
    });
    print("Available goals: ``mergeGoalSetsWithGoals(goals)``");
    print("Enter Ctrl + D to quit");
    while (true) {
        process.write("> ");
        String? rawLine = process.readLine(); // workaround for https://github.com/ceylon/ceylon.language/issues/372
        if (is Null rawLine) {
            process.writeLine();
            return;
        }
        assert(exists rawLine);
        String line = rawLine.trimmed;
        value result = runEngine(goals, "", line.split().sequence);
        assert(exists msg = exitMessages[result.exitCode]);
        print(msg);
    }
}