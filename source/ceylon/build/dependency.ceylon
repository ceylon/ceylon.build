import ceylon.collection { LinkedList }

shared class Dependency(task, {Task*} taskDependencies = []) {
    shared Task task;
    value dependencies = LinkedList<Task>(taskDependencies);
    shared Boolean hasDependencies => dependencies.empty;
    shared void removeDependency(Task dependency) {
        dependencies.removeElement(dependency);
    }
    string => "``task.name`` -> ``dependencies``";
}

shared {Dependency*}  analyzeDependencyCycles({Task+} tasks) {
    value definitions = { for (task in tasks) Dependency(task, task.dependencies) };
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
                definition.removeDependency(definitionToRemove.task);
            }
        }
        remainingDefinitions = filteredDefinitions;
    }
    return [];
}
