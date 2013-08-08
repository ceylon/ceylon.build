import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet }

shared {Task*} buildTaskExecutionList(TasksDefinitionsMap definitions, String[] arguments, Writer writer) {
    value tasksRequested = findTasksToExecute(definitions, arguments, writer);
    MutableList<Task> tasksToExecute = LinkedList<Task>();
    for (task in tasksRequested) {
        tasksToExecute.addAll(linearize(task, definitions));
    }
    return reduce(tasksToExecute);
}

shared {Task*} findTasksToExecute(TasksDefinitionsMap definitions, String[] arguments, Writer writer) {
    MutableList<Task> tasks = LinkedList<Task>();
    for (taskName in arguments) {
        if (!taskName.startsWith(argumentPrefix)) {
            for (task -> taskDependencies in definitions) {
                if (task.name.equals(taskName)) {
                    tasks.add(task);
                    break;
                }
            } else {
                writer.error("# task '``taskName``' not found, stopping");
                return {};
            }
        }
    }
    return tasks;
}

shared {Task*} linearize(Task task, TasksDefinitionsMap definitions) {
    MutableList<Task> tasks = LinkedList<Task>();
    assert (exists taskDependencies = definitions[task]);
    for (Task dependency in taskDependencies) {
        tasks.addAll(linearize(dependency, definitions));
    }
    tasks.add(task);
    return tasks;
}

shared {Task*} reduce({Task*} tasks) {
    MutableSet<Task> reducedTasksSet = HashSet<Task>();
    MutableList<Task> reducedTasks = LinkedList<Task>();
    for (Task task in tasks) {
        if (!reducedTasksSet.contains(task)) {
            reducedTasks.add(task);
            reducedTasksSet.add(task);
        }
    }
    return reducedTasks;
}