import ceylon.collection { HashMap }

"Iterable of `Task` with their eventual dependencies.
 
 A `TasksDefinitions` is an iterable of:
 - `Task -> {Task*}`: corresponds to the declaration of a task with its ordered dependencies.
 
 or
 
 - `Task`: corresponds to a task without any dependencies.
  
 Order of tasks in this iterable doesn't matter.
 
 What is important is the order of tasks in the dependencies part of a `Task -> {Task*}` declaration."
shared alias TasksDefinitions => {<<Task -> {Task*}>|Task>*};

"Map of `Task` with their dependencies `{Task*}`.
 
 As for `TasksDefinitions`, order of dependencies is important."
shared alias TasksDefinitionsMap => Map<Task, {Task*}>;


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
shared void build(TasksDefinitions tasksDefinitions) {
    Integer exitCode = buildTasks(taskDefinitionMap(tasksDefinitions), process.arguments, consoleWriter);
    process.exit(exitCode);
}

"Convert a `TasksDefinitions` to a `TasksDefinitionsMap`.
 
 Items in `TasksDefinitions` without any dependencies defined (i.e. `Task` and not `Task -> {Task*}`) will be used with
 an empty dependencies list."
shared TasksDefinitionsMap taskDefinitionMap(TasksDefinitions tasksDefinitions) {
    HashMap<Task, {Task*}> definitions = HashMap<Task, {Task*}>();
    for (definition in tasksDefinitions) {
        if (is Task definition) {
            definitions.put(definition, []);
        }
        else if (is <Task -> {Task*}> definition) {
            definitions.put(definition.key, definition.item);
        } 
    }
    return definitions;
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

shared Integer buildTasks(TasksDefinitionsMap tasks, String[] arguments, Writer writer) {
    writer.info("## ceylon.build");
    value cycles = analyzeDependencyCycles(tasks);
    if (cycles.empty) {
        value tasksToRun = buildTaskExecutionList(tasks, process.arguments, writer);
        return runTasks(tasksToRun, arguments, tasks.keys, writer);
    } else {
        writer.error("# task dependency cycle found between: ``cycles``");
        return exitCode.dependencyCycleFound;
    }
}