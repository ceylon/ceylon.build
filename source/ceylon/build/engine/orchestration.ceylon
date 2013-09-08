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
    MutableList<Goal> goals = LinkedList<Goal>();
    for (goalName in arguments) {
        if (!goalName.startsWith(argumentPrefix)) {
            for (goal in definitions) {
                if (goal.name.equals(goalName)) {
                    goals.add(goal);
                    break;
                }
            } else {
                writer.error("# goal '``goalName``' not found, stopping");
                return {};
            }
        }
    }
    return goals;
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
    MutableSet<Goal> reducedGoalsSet = HashSet<Goal>();
    MutableList<Goal> reducedGoals = LinkedList<Goal>();
    for (Goal goal in goals) {
        if (!reducedGoalsSet.contains(goal)) {
            reducedGoals.add(goal);
            reducedGoalsSet.add(goal);
        }
    }
    return reducedGoals;
}