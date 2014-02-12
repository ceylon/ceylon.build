import ceylon.build.task { Writer }
import ceylon.collection { HashSet, MutableSet }

{String*} buildGoalExecutionList(GoalDefinitions definitions, [String*] arguments, Writer writer) {
    value goalsRequested = findGoalsToExecute(definitions, arguments, writer);
    value goalsToExecute = SequenceBuilder<String>();
    for (goal in goalsRequested) {
        goalsToExecute.appendAll(linearize(goal, definitions));
    }
    return reduce(goalsToExecute.sequence, definitions);
}

{String*} findGoalsToExecute(GoalDefinitions definitions, [String*] arguments, Writer writer) {
    value goalsToExecute = SequenceBuilder<String>();
    for (argument in arguments) {
        if (!argument.startsWith(argumentPrefix)) {
            if (definitions.defines(argument)) {
                goalsToExecute.append(argument);
            } else {
                writer.error("# goal '``argument``' not found, stopping");
                return {};
            }
        }
    }
    return goalsToExecute.sequence;
}

{String*} linearize(String goal, GoalDefinitions definitions) {
    value goals = SequenceBuilder<String>();
    value properties = definitions.properties(goal);
    for (dependency in properties.dependencies) {
        goals.appendAll(linearize(dependency, definitions));
    }
    goals.append(goal);
    return goals.sequence;
}

{String*} reduce({String*} goals, GoalDefinitions definitions) {
    MutableSet<String> reducedGoalsNames = HashSet<String>();
    value reducedGoals = SequenceBuilder<String>();
    for (goal in goals) {
        value properties = definitions.properties(goal);
        value task = properties.task;
        if (exists task, !reducedGoalsNames.contains(goal)) {
            reducedGoals.append(goal);
            reducedGoalsNames.add(goal);
        }
    }
    return reducedGoals.sequence;
}
