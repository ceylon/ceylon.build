import ceylon.build.task { Writer }
import ceylon.collection { HashSet, MutableSet, ArrayList }

{String*} buildGoalExecutionList(GoalDefinitions definitions, [String*] arguments, Writer writer) {
    value goalsRequested = findGoalsToExecute(definitions, arguments, writer);
    value goalsToExecute = ArrayList<String>();
    for (goal in goalsRequested) {
        goalsToExecute.addAll(linearize(goal, definitions));
    }
    return reduce(goalsToExecute.sequence(), definitions);
}

{String*} findGoalsToExecute(GoalDefinitions definitions, [String*] arguments, Writer writer) {
    value goalsToExecute = ArrayList<String>();
    for (argument in arguments) {
        if (!argument.startsWith(argumentPrefix)) {
            if (definitions.defines(argument)) {
                goalsToExecute.add(argument);
            } else {
                writer.error("# goal '``argument``' not found, stopping");
                return {};
            }
        }
    }
    return goalsToExecute.sequence();
}

{String*} linearize(String goal, GoalDefinitions definitions) {
    value goals = ArrayList<String>();
    value properties = definitions.properties(goal);
    for (dependency in properties.dependencies) {
        goals.addAll(linearize(dependency, definitions));
    }
    goals.add(goal);
    return goals.sequence();
}

{String*} reduce({String*} goals, GoalDefinitions definitions) {
    MutableSet<String> reducedGoalsNames = HashSet<String>();
    value reducedGoals = ArrayList<String>();
    for (goal in goals) {
        value properties = definitions.properties(goal);
        value task = properties.task;
        if (exists task, !reducedGoalsNames.contains(goal)) {
            reducedGoals.add(goal);
            reducedGoalsNames.add(goal);
        }
    }
    return reducedGoals.sequence();
}
