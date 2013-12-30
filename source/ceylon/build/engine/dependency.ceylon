import ceylon.collection { LinkedList, HashSet }

alias DependencyGraph => {<String->{String*}>*};

"Returns the list of dependencies names, without duplicates in the order in which they are defined.
 Not that this "
{String*} dependencies(GoalProperties properties) {
    value dependencies = SequenceBuilder<String>();
    value alreadyAddedDependencies = HashSet<String>();
    for (dependency in properties.dependencies) {
        if (!alreadyAddedDependencies.contains(dependency)) {
            dependencies.append(dependency);
            alreadyAddedDependencies.add(dependency);
        }
    }
    return dependencies.sequence;
}

class Dependency(goal, {String*} goals = []) {
    
    shared String goal;
    
    value _dependencies = LinkedList<String>(goals);
    
    shared {String*} dependencies => _dependencies.sequence;
    
    shared Boolean hasNoDependencies => _dependencies.empty;
    
    shared Boolean hasDependencies => !_dependencies.empty;
    
    shared void removeDependency(String dependency) {
        _dependencies.removeFirst(dependency);
    }
    
    string => "``goal`` -> ``_dependencies``";
}

DependencyGraph analyzeDependencyCycles(DependencyGraph goals) {
    value definitions = { for (goal in goals) Dependency(goal.key, goal.item) };
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
            return [ for (dependency in unresolvedThisRound) dependency.goal->dependency.dependencies ];
        } else {
            removeDependenciesToResolvedDefinitions(unresolvedThisRound, resolvedThisRound);
        }
        unresolved = unresolvedThisRound;
    }
    return [];
}

void removeDependenciesToResolvedDefinitions({Dependency*} unresolvedThisRound, {Dependency*} resolvedThisRound) {
    for (definition in unresolvedThisRound) {
        for (definitionToRemove in resolvedThisRound) {
            definition.removeDependency(definitionToRemove.goal);
        }
    }
}
