import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet }

String taskNames({Task*} tasks) => "[``", ".join({for (task in tasks) task.name})``]";


shared void build(TasksDefinitions tasks) {
    print("# ceylon.build");
    value dependencies = buildDependencies(tasks);
    value cycles = analyzeDependencyCycles(dependencies);
    if (cycles.empty) {
        value tasksToRun = buildTaskExecutionList(tasks, process.arguments);
        runTasks(tasksToRun, tasks.keys);
    } else {
         print("task dependency cycle found between: ``cycles``");
    }
}

{Dependency*} buildDependencies(TasksDefinitions tasks) =>
    { for (task -> dependencies in tasks) Dependency(task, dependencies) };

{Task*} buildTaskExecutionList(TasksDefinitions definitions, String[] arguments) {
    MutableList<Task> tasks = LinkedList<Task>();
    for (taskName in arguments) {
        if (!taskName.startsWith("-D")) {
            for (task -> taskDependencies in definitions) {
                if (task.name.equals(taskName)) {
                    tasks.addAll(linearize(task, definitions));
                    break;
                }
            } else {
                print("task '``taskName``' not found");
                return {};
            }
        }
    }
    return reduce(tasks);
}

{Task*} linearize(Task task, TasksDefinitions definitions) {
    MutableList<Task> tasks = LinkedList<Task>();
    assert (exists taskDependencies = definitions[task]);
    for (Task dependency in taskDependencies) {
        tasks.addAll(linearize(dependency, definitions));
    }
    tasks.add(task);
    return tasks;
}

{Task*} reduce({Task*} tasks) {
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

void runTasks({Task*} tasks, {Task*} definitions) {
    if (tasks.empty) {
    print("no task to run");
    print("available tasks are: ``taskNames(definitions)``");
    } else {
        print("running tasks: ``taskNames(tasks)`` in order");
        for (task in tasks) {
            task.process();
        }
    }
}