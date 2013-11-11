import ceylon.build.task { Goal }
import ceylon.collection { LinkedList, HashSet, MutableSet }

class Dependency(goal, {Goal*} goals = []) {
    
    shared Goal goal;
    
    value dependencies = LinkedList<Goal>(goals);
    
    shared Boolean hasNoDependencies => dependencies.empty;
    
    shared Boolean hasDependencies => !dependencies.empty;
    
    shared void removeDependency(Goal dependency) {
        dependencies.removeElement(dependency);
    }
    
    shared {Dependency*} remainingDependencies({Goal*} resolvedGoals) {
        value remaining = LinkedList<Dependency>();
        for (goal in dependencies) {
            value dependency = Dependency(goal, goal.dependencies);
            for(resolvedGoal in resolvedGoals) {
                dependency.removeDependency(resolvedGoal);
            }
            remaining.add(dependency);
        }
        return remaining;
    }
    
    string => "``goal.name`` -> ``dependencies``";
}

{Dependency*}  analyzeDependencyCycles({Goal+} goals) {
    value goalsNames = HashSet<String>({ for (goal in goals) goal.name });
    value definitions = { for (goal in goals) Dependency(goal, goal.dependencies) };
    value resolved = LinkedList<Goal>();
    variable {Dependency*} unresolved = definitions;
    while (!unresolved.empty) {
        "goals definitions that are resolved (have no dependencies on definitions in `unresolvedThisRound`)"
        value resolvedThisRound = LinkedList<Dependency>();
        "goals definitions for which we need still to resolve dependencies"
        value unresolvedThisRound = LinkedList<Dependency>();
        for (definition in unresolved) {
            if (definition.hasNoDependencies) {
                resolvedThisRound.add(definition);
            } else {
                unresolvedThisRound.add(definition);
            }
        }
        if (resolvedThisRound.empty) {
            value newDefinitions = internalGoalDefinitions(unresolvedThisRound, resolved, goalsNames);
            if (newDefinitions.empty) {
                return unresolvedThisRound;
            } else {
                unresolvedThisRound.addAll(newDefinitions);
            }
        } else {
            removeDependenciesToResolvedDefinitions(unresolvedThisRound, resolvedThisRound);
        }
        unresolved = unresolvedThisRound;
        resolved.addAll({ for (definition in resolvedThisRound) definition.goal });
    }
    return [];
}

{Dependency*} internalGoalDefinitions({Dependency*} unresolvedThisRound, {Goal*} resolved, MutableSet<String> goalsNames) {
    value internalDependencies = LinkedList<Dependency>();
    for (definition in unresolvedThisRound) {
        value remaingDependencies = definition.remainingDependencies(resolved);
        for (remainingDependency in remaingDependencies) {
            String name = remainingDependency.goal.name;
            if (!goalsNames.contains(name)) {
                goalsNames.add(name);
                internalDependencies.add(remainingDependency);
            }
        }
    }
    return internalDependencies;
}

void removeDependenciesToResolvedDefinitions({Dependency*} unresolvedThisRound, {Dependency*} resolvedThisRound) {
    for (definition in unresolvedThisRound) {
        for (definitionToRemove in resolvedThisRound) {
            definition.removeDependency(definitionToRemove.goal);
        }
    }
}
