import ceylon.build.task { Goal, Writer }
import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet }

shared {Goal*} buildGoalExecutionList({Goal+} definitions, String[] arguments, Writer writer) {
    value goalsRequested = findGoalsToExecute(definitions, arguments, writer);
    MutableList<Goal> goalsToExecute = LinkedList<Goal>();
    for (goal in goalsRequested) {
        goalsToExecute.addAll(linearize(goal));
    }
    return reduce(goalsToExecute);
}

shared {Goal*} findGoalsToExecute({Goal+} definitions, String[] arguments, Writer writer) {
    MutableList<Goal> goalsToExecute = LinkedList<Goal>();
    for (argument in arguments) {
        if (!argument.startsWith(argumentPrefix)) {
            for (definition in definitions) {
                if (definition.name.equals(argument)) {
                    goalsToExecute.add(definition);
                    break;
                }
            } else {
                writer.error("# goal '``argument``' not found, stopping");
                return {};
            }
        }
    }
    return goalsToExecute;
}

shared {Goal*} linearize(Goal goal) {
    MutableList<Goal> goals = LinkedList<Goal>();
    for (Goal dependency in goal.dependencies) {
        goals.addAll(linearize(dependency));
    }
    goals.add(goal);
    return goals;
}

shared {Goal*} reduce({Goal*} goals) {
    MutableSet<String> reducedGoalsNames = HashSet<String>();
    MutableList<Goal> reducedGoals = LinkedList<Goal>();
    for (Goal goal in goals) {
        if (!reducedGoalsNames.contains(goal.name) && !goal.tasks.empty) {
            reducedGoals.add(goal);
            reducedGoalsNames.add(goal.name);
        }
    }
    return reducedGoals;
}