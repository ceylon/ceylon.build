
String argumentPrefix = "-D";

Integer runTasks({Task*} tasks, String[] arguments, {Task*} availableTasks, Writer writer) {
    if (tasks.empty) {
        writer.error("# no task to run, available tasks are: ``tasksNames(availableTasks)``");
        return exitCode.noTaskToRun;
    } else {
        writer.info("# running tasks: ``tasks`` in order");
        for (task in tasks) {
            value taskArguments = filterArgumentsForTask(task, arguments);
            writer.info("# running ``task.name``(``", ".join(taskArguments)``)");
            try {
                if (!task.process(taskArguments, writer)) {
                    writer.error("# task ``task`` failure, stopping");
                    return exitCode.errorOnTaskExecution;
                }
            } catch (Exception exception) {
                writer.error("# error during task execution ``task``, stopping");
                writer.exception(exception);
                return exitCode.errorOnTaskExecution;
            }
        }
        return exitCode.success;
    }
}

String tasksNames({Task*} tasks) => "[``", ".join({for (task in tasks) task.name})``]";

shared String[] filterArgumentsForTask(Task task, String[] arguments) {
    String prefix = "``argumentPrefix````task.name``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)]; 
}