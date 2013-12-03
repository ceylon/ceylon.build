import ceylon.language.meta.declaration { ValueDeclaration, Module }
import ceylon.build.task { Goal }
import ceylon.build.engine { runEngine, exitCodes }

"A console that takes a ceylon module as input, find the top level goals and run an interactive console."
shared void console(
    "The module to introspect" Module m) {
    
    //
    value exitMessages = LazyMap<Integer, String>({
        exitCodes.success->"Success",
        exitCodes.dependencyCycleFound->"Dependency Cycle Found",
        exitCodes.invalidGoalFound->"Invalid goal found",
        exitCodes.duplicateGoalsFound->"Duplicate goals found",
        exitCodes.noGoalToRun->"No goal to run",
        exitCodes.errorOnTaskExecution->"Error on task execution"
    });
    
    //
    // Discover all goals
    {Goal*} goals = {for (pkg in m.members)
        for (decl in pkg.members<ValueDeclaration>())
            if (is Goal goal = decl.get())
                goal
    };

    //
    if (exists first = goals.first) {
        {Goal+} nonEmptyGoals = {first,*goals.rest};
        print("Available goals:");
        for (goal in goals) {
            print(goal.name);
        }
        print("");
        while (true) {
            process.write("> ");
            String line = process.readLine().trimmed;
            value result = runEngine(nonEmptyGoals,"",line.split().sequence);
            assert(exists msg = exitMessages[result.exitCode]);
            print(msg);
        }
    } else {
        print("No goal founds");
    }
}