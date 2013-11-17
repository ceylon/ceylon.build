import ceylon.build.task { Goal, Writer }
import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet }

String dash = "-";

{Goal*} buildGoalExecutionList({Goal+} definitions, [String*] arguments, Writer writer) {
    value goalsRequested = findGoalsToExecute(definitions, arguments, writer);
    MutableList<Goal> goalsToExecute = LinkedList<Goal>();
    for (goal in goalsRequested) {
        goalsToExecute.addAll(linearize(goal));
    }
    return resumeFrom(reduce(goalsToExecute), arguments, writer);
}

{Goal*} findGoalsToExecute({Goal+} definitions, [String*] arguments, Writer writer) {
    MutableList<Goal> goalsToExecute = LinkedList<Goal>();
    for (argument in arguments) {
        if (!argument.startsWith(dash)) {
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

{Goal*} linearize(Goal goal) {
    MutableList<Goal> goals = LinkedList<Goal>();
    for (Goal dependency in goal.dependencies) {
        goals.addAll(linearize(dependency));
    }
    goals.add(goal);
    return goals;
}

[Goal*] reduce({Goal*} goals) {
    MutableSet<String> reducedGoalsNames = HashSet<String>();
    MutableList<Goal> reducedGoals = LinkedList<Goal>();
    for (Goal goal in goals) {
        if (!reducedGoalsNames.contains(goal.name) && !goal.tasks.empty) {
            reducedGoals.add(goal);
            reducedGoalsNames.add(goal.name);
        }
    }
    return reducedGoals.sequence;
}

{Goal*} resumeFrom([Goal*] goals, [String*] arguments, Writer writer) {
    if (goals.empty) {
        return [];
    }
    for (argument in arguments) {
        value resumeFromOption = "--rf=";
        if (argument.startsWith(resumeFromOption)) {
            value from = argument.spanFrom(resumeFromOption.size);
            for (index -> goal in entries(goals)) {
                if (goal.name == from) {
                    writer.error("# resume from ``from``");
                    return goals.spanFrom(index);
                }
            } else {
                writer.error("# No goal ``from`` to resume from found, stopping");
                return [];
            }
        }
    }
    return goals;
}
