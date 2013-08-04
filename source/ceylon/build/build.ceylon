import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet, HashMap }

shared alias TasksDefinitions => {Entry<Task, {Task*}>*};
shared alias TasksDefinitionsMap => Map<Task, {Task*}>;

shared interface Writer {
    shared formal void info(String message);
    shared formal void error(String message);
    shared default void exception(Exception exception) => error(exception.message);
}

object consoleWriter satisfies Writer {
    
    shared actual void error(String message) {
        print(message);
    }
    
    shared actual void info(String message) {
        process.writeErrorLine(message);
    }
    shared actual void exception(Exception exception) {
        exception.printStackTrace();
    }
}

String argumentPrefix = "-D";

shared void build(TasksDefinitions tasksDefinitions) {
    buildTasks(HashMap<Task, {Task*}>(tasksDefinitions), consoleWriter);
}

shared void buildTasks(TasksDefinitionsMap tasks, Writer writer) {
    writer.info("## ceylon.build");
    value cycles = analyzeDependencyCycles(tasks);
    if (cycles.empty) {
        value tasksToRun = buildTaskExecutionList(tasks, process.arguments, writer);
        runTasks(tasksToRun, process.arguments, tasks.keys, writer);
    } else {
        writer.error("# task dependency cycle found between: ``cycles``");
    }
}

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

String tasksNames({Task*} tasks) => "[``", ".join({for (task in tasks) task.name})``]";

void runTasks({Task*} tasks, String[] arguments, {Task*} availableTasks, Writer writer) {
    if (tasks.empty) {
        writer.error("# no task to run, available tasks are: ``tasksNames(availableTasks)``");
    } else {
        writer.info("# running tasks: ``tasks`` in order");
        for (task in tasks) {
            value taskArguments = filterArgumentsForTask(task, arguments);
            writer.info("# running ``task.name``(``", ".join(taskArguments)``)");
            try {
                task.process(taskArguments, writer);
            } catch (Exception exception) {
                writer.error("# error during task execution ``task``, stopping");
                writer.exception(exception);
                break;
            }
        }
    }
}

shared String[] filterArgumentsForTask(Task task, String[] arguments) {
    String prefix = "``argumentPrefix````task.name``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)]; 
}