import ceylon.collection { HashMap, HashSet, MutableSet }

"""Launch the task based engine using `TasksDefinitions`.
   
   Command line arguments retrieved by `process.arguments` will be used to determine which tasks in `TasksDefinitions`
   have to be run.
   
   All arguments passed to this program will be understood as task names.
   Except ones starting with `"-D"` which will be understood as task parameters.
   
   Given a list of arguments, program will look for task names in argument list and will try to find the corresponding
   `Task`in `tasksDefinitions`.
   If no corresponding task is found, an error will be raised and program will exit.
   
   For each task found, dependencies will be linearized to ensure that if task `a` depends on task `b`, task `b`
   will be executed before `a` even if only `a` was asked for.
   Tasks execution list will then be reduced so that one task is only executed once during program execution.
   If tasks dependencies cycle are found, an error will be raised and program will exit.
   
   Tasks will be run in the order they were given to the command line, except if one task before in the command line has
   a dependency on a later task. In a such case, later task will be moved before in order to be consistent
   with dependencies.
   Example:
   Consider the following tasks with their dependencies:
   ```ceylon
   build({
       a -> [],
       b -> [c, d],
       c -> [d],
       d -> []
   });
   ```
   Launching the program with tasks `a, b, c` (in order) will result in the execution of `a, d, c, b` (still in order) 
   """
shared void build(
		String project,
		String rootPath,
		{Task*} tasks) {
    Integer exitCode = buildTasks(tasksSet(tasks), process.arguments, consoleWriter);
    process.exit(exitCode);
}

"Convert a `TasksDefinitions` to a `TasksDefinitionsMap`.
 
 Items in `TasksDefinitions` without any dependencies defined (i.e. `Task` and not `Task -> {Task*}`) will be used with
 an empty dependencies list."
shared Set<Task> tasksSet({Task*} tasks) {
    return HashSet<Task>(tasks);
}

"List of program exit code"
object exitCode {
    "Success exit code as per standard conventions"
    shared Integer success = 0;
    
    "Exit code returned when a dependency cycle has been found in the given `TasksDefinitions`"
    shared Integer dependencyCycleFound = 1;
    
    "Exit code returned when there is no task to be run.
     
     This could be because no task has been requested or because the requested task doesn't exists."
    shared Integer noTaskToRun = 2;
    
    "Exit code returned when a task failed"
    shared Integer errorOnTaskExecution = 3;
}

shared Integer buildTasks(Set<Task> tasks, String[] arguments, Writer writer) {
    writer.info("## ceylon.build");
    value cycles = analyzeDependencyCycles(tasks);
    if (cycles.empty) {
        value tasksToRun = buildTaskExecutionList(tasks, process.arguments, writer);
        return runTasks(tasksToRun, arguments, tasks, writer);
    } else {
        writer.error("# task dependency cycle found between: ``cycles``");
        return exitCode.dependencyCycleFound;
    }
}