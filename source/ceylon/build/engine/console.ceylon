import ceylon.build.task { Goal, GoalSet }
import ceylon.collection { LinkedList }


"An interactive console."
void console({<Goal|GoalSet>+} goals) {
    value exitMessages = LazyMap<Integer, String>({
        exitCodes.success->"Success",
        exitCodes.dependencyCycleFound->"Dependency Cycle Found",
        exitCodes.invalidGoalFound->"Invalid goal found",
        exitCodes.duplicateGoalsFound->"Duplicate goals found",
        exitCodes.noGoalToRun->"No goal to run",
        exitCodes.errorOnTaskExecution->"Error on task execution"
    });
    LinkedList<Goal> all = LinkedList<Goal>();
    for (goal in goals) {
        if (is Goal goal) {
            all.add(goal);
        } else if (is GoalSet goal) {
            all.addAll(goal.goals);
        }
    }
    print("Available goals:");
    for (goal in all) {
        print(goal.name);
    }
    print("");
    while (true) {
        process.write("> ");
        String line = process.readLine().trimmed;
        value result = runEngine(goals,"",line.split().sequence);
        assert(exists msg = exitMessages[result.exitCode]);
        print(msg);
    }
}