import ceylon.build.task { Goal, Writer, GoalGroup }
import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet }

shared {Goal*} buildGoalExecutionList({<Goal|GoalGroup>+} definitions, String[] arguments, Writer writer) {
    value goalsRequested = findGoalsToExecute(definitions, arguments, writer);
    MutableList<Goal> goalsToExecute = LinkedList<Goal>();
    for (goal in goalsRequested) {
        goalsToExecute.addAll(linearize(goal));
    }
    return reduce(goalsToExecute);
}

shared {Goal*} findGoalsToExecute({<Goal|GoalGroup>+} definitions, String[] arguments, Writer writer) {
    MutableList<Goal> goalsToExecute = LinkedList<Goal>();
    for (argument in arguments) {
        if (!argument.startsWith(argumentPrefix)) {
            for (definition in definitions) {
                if (definition.name.equals(argument)) {
                    switch (definition)
                    case (is Goal) {
                        goalsToExecute.add(definition);
                    }
                    case (is GoalGroup) {
                        goalsToExecute.addAll(goalsList(definition.goals));
                    }
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
    for (<Goal|GoalGroup> dependency in goal.dependencies) {
        switch (dependency)
        case (is Goal) {
            goals.addAll(linearize(dependency));
        }
        case (is GoalGroup) {
            value groupGoals = goalsList(dependency.goals);
            for (groupGoal in groupGoals) {
                goals.addAll(linearize(groupGoal));
            }
        }
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