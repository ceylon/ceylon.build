import ceylon.build.task { Goal, GoalGroup }
import ceylon.collection { LinkedList }

shared class Dependency(goal, {Goal*} goals = []) {
    shared Goal goal;
    value dependencies = LinkedList<Goal>(goals);
    shared Boolean hasDependencies => dependencies.empty;
    shared void removeDependency(Goal dependency) {
        dependencies.removeElement(dependency);
    }
    string => "``goal.name`` -> ``dependencies``";
}

shared {Dependency*}  analyzeDependencyCycles({<Goal|GoalGroup>+} goals) {
    value definitions = LinkedList<Dependency>();
    for (goal in goals) {
        switch (goal)
        case (is Goal) {
            definitions.add(Dependency(goal, goalsList(goal.dependencies)));
        }
        case (is GoalGroup) {
            for (Goal g in goalsList(goal.goals)) {
                definitions.add(Dependency(g, goalsList(g.dependencies)));
            }
        }
    }
    variable {Dependency*} remainingDefinitions = definitions;
    while (!remainingDefinitions.empty) {
        value toRemove = LinkedList<Dependency>();
        value filteredDefinitions = LinkedList<Dependency>();
        for (definition in remainingDefinitions) {
            if (definition.hasDependencies) {
                toRemove.add(definition);
            } else {
                filteredDefinitions.add(definition);
            }
        }
        if (toRemove.empty) {
            return filteredDefinitions;
        }
        for (definition in filteredDefinitions) {
            for (definitionToRemove in toRemove) {
                definition.removeDependency(definitionToRemove.goal);
            }
        }
        remainingDefinitions = filteredDefinitions;
    }
    return [];
}
