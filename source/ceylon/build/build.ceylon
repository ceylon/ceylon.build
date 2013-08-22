import ceylon.collection { HashMap }
import ceylon.build { Writer }

"""Launch the task engine using.
   
   Command line arguments retrieved by `process.arguments` will be used to determine which tasks in `TasksDefinitions`
   have to be run.
   
   All arguments passed to this program will be understood as task names.
   Except ones starting with `"-D"` which will be understood as task parameters.
   
   Given a list of arguments, program will look for task names in argument list and will try to find the corresponding
   `Task`.
   If no corresponding task is found, an error will be raised and program will exit.
   
   For each task found, dependencies will be linearized to ensure that if task `a` depends on task `b`, task `b`
   will be executed before `a` even if only `a` was asked for.
   Tasks execution list will then be reduced so that a task is only executed once during program execution.
   If tasks dependencies cycle are found, an error will be raised and program will exit.
   
   Tasks will be run in the order they were given to the command line, except if one task before in the command line has
   a dependency on a later task. In a such case, later task will be moved before in order to maintain dependencies
   consistency
   
   Example:
   Consider the following tasks with their dependencies:
   ```ceylon
   value a = Task {
       name = "a";
       doA;
   };
   value b = Task {
       name = "b";
       doD;
   };
   value c = Task {
       name = "c";
       doC;
       dependencies = [b];
   };
   value d = Task {
       name = "d";
       doB;
       dependencies = [c, b];
   };
   build(
       project = "My Project";
       rootPath = ".";
       a, b, c, d
   });
   ```
   Launching the program with tasks `a, d, c` (in order) will result in the execution of `a, b, c, d` (still in order) 
   """
shared void build(
		String project,
		String rootPath,
		{Task+} tasks) {
    Integer exitCode = buildTasks(project, tasks, process.arguments, consoleWriter);
    process.exit(exitCode);
}

"List of program exit code"
object exitCode {
    "Success exit code as per standard conventions"
    shared Integer success = 0;
    
    "Exit code returned when a dependency cycle has been found"
    shared Integer dependencyCycleFound = 1;
    
    "Exit code returned when there is no task to be run.
     
     This happens because no task has been requested or because the requested task doesn't exists."
    shared Integer noTaskToRun = 2;
    
    "Exit code returned when a task failed"
    shared Integer errorOnTaskExecution = 3;
    
    "Exit code returned when multiples `Task` have the same name"
    shared Integer duplicateTasksFound = 4;
}

shared Integer buildTasks(String project, {Task+} tasks, String[] arguments, Writer writer) {
    Integer startTime = process.milliseconds;
    writer.info("## ceylon.build: ``project``");
    value code = processTasks(tasks, arguments, writer);
    Integer endTime = process.milliseconds;
    String duration = "duration ``(endTime - startTime) / 1000``s";
    if (code == exitCode.success) {
        writer.info("## success - ``duration``");
    } else {
        writer.error("## failure - ``duration``");
    }
    return code;
}

Integer processTasks({Task+} tasks, String[] arguments, Writer writer) {
    value duplicateTasks = findDuplicateTasks(tasks);
    if (duplicateTasks.empty) {
        value cycles = analyzeDependencyCycles(tasks);
        if (cycles.empty) {
            value tasksToRun = buildTaskExecutionList(tasks, process.arguments, writer);
            return runTasks(tasksToRun, arguments, tasks, writer);
        } else {
            writer.error("# task dependency cycle found between: ``cycles``");
            return exitCode.dependencyCycleFound;
        }
    } else {
        writer.error("# duplicate task names found: ``duplicateTasks``");
        return exitCode.duplicateTasksFound;
    }
}

shared {String*} findDuplicateTasks({Task+} tasks) {
    value map = HashMap<String, Integer>();
    for (task in tasks) {
        String name = task.name;
        Integer count = map.get(name) else 0;
        map.put(name, count + 1);
    }
    return [ for (name -> count in map) if (count > 1) name ];
}