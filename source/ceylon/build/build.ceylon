import ceylon.collection { LinkedList, MutableList, HashSet, MutableSet, HashMap }

shared alias TasksDefinitions => {Entry<Task, {Task*}>*};
shared alias TasksDefinitionsMap => Map<Task, {Task*}>;

shared void build(TasksDefinitions tasksDefinitions) {
    Builder(print).build(HashMap<Task, {Task*}>(tasksDefinitions));
}

shared class Builder(void write(String message) => print(message)) {
    
    String argumentPrefix = "-D";
    
    void log(String message) => write(message);
    
    shared void build(TasksDefinitionsMap tasks) {
        log("## ceylon.build");
        value cycles = analyzeDependencyCycles(tasks);
        if (cycles.empty) {
            value tasksToRun = buildTaskExecutionList(tasks, process.arguments);
            runTasks(tasksToRun, process.arguments, tasks.keys);
        } else {
            log("# task dependency cycle found between: ``cycles``");
        }
    }
    shared {Task*} buildTaskExecutionList(TasksDefinitionsMap definitions, String[] arguments) {
        value tasksRequested = findTasksToExecute(definitions, arguments);
        MutableList<Task> tasksToExecute = LinkedList<Task>();
        for (task in tasksRequested) {
            tasksToExecute.addAll(linearize(task, definitions));
        }
        return reduce(tasksToExecute);
    }
    
    shared {Task*} findTasksToExecute(TasksDefinitionsMap definitions, String[] arguments) {
        MutableList<Task> tasks = LinkedList<Task>();
        for (taskName in arguments) {
            if (!taskName.startsWith(argumentPrefix)) {
                for (task -> taskDependencies in definitions) {
                    if (task.name.equals(taskName)) {
                        tasks.add(task);
                        break;
                    }
                } else {
                    log("# task '``taskName``' not found, stopping");
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
    
    void runTasks({Task*} tasks, String[] arguments, {Task*} availableTasks) {
        if (tasks.empty) {
            log("# no task to run, available tasks are: ``tasksNames(availableTasks)``");
        } else {
            log("# running tasks: ``tasks`` in order");
            for (task in tasks) {
                value taskArguments = filterArgumentsForTask(task, arguments);
                log("# running ``task.name``(``", ".join(taskArguments)``)");
                task.process(taskArguments);
                // TODO handle tasks failure
            }
        }
    }
    
    shared String[] filterArgumentsForTask(Task task, String[] arguments) {
        String prefix = "``argumentPrefix````task.name``:";
        return [
                for (argument in arguments)
                if (argument.startsWith(prefix))
                argument.spanFrom(prefix.size)
                ]; 
    }
}