import ceylon.build.task { Goal, GoalSet, Writer }

"List of program exit code"
shared object exitCodes {
    "Success exit code as per standard conventions"
    shared Integer success = 0;
    
    "Exit code returned when an invalid `Goal` is found
     
     This can happen if a goal name contains forbidden characters"
    shared Integer invalidGoalFound = 1;
    
    "Exit code returned when multiples `Goal` have the same name"
    shared Integer duplicateGoalsFound = 2;
    
    "Exit code returned when a dependency cycle has been found"
    shared Integer dependencyCycleFound = 3;
    
    "Exit code returned when there is no goal to be run.
     
     This happens because no goal has been requested or because the requested goal doesn't exists."
    shared Integer noGoalToRun = 4;
    
    "Exit code returned when a goal's task failed"
    shared Integer errorOnTaskExecution = 5;
}

"""Starts the goal engine and exit with one of [[exitCodes]] exit code.
   
   Command line arguments retrieved by `process.arguments` will be used to determine which goals have to be run.
   
   All arguments passed to this program will be understood as a goal.
   Except ones starting with `"-D"` which will be understood as parameters for a goal's task.
   
   Given a list of arguments, program will look for goal names in argument list and will try to find the
   corresponding `Goal`.
   If no corresponding goal is found, an error will be raised and program will exit.
   
   For each goal found, dependencies will be linearized to ensure that if goal `a` depends on goal `b`, goal `b`
   will be executed before `a` even if only `a` was requested or if `b` was requested after `a`.
   Goals execution list will then be reduced so that a goal is only executed once during program execution.
   If goals dependencies cycle are found, an error will be raised and program will exit.
   
   Goals will be run in the order they were given to the command line, except if one goal before in the command line has
   a dependency on a later goal. In a such case, later goal will be moved before in order to maintain dependencies
   consistency.
   
   Example:
   Consider the following goals with their dependencies:
   ```ceylon
   value a = Goal {
       name = "a";
       doA
   };
   value b = Goal {
       name = "b";
       doB
   };
   value c = Goal {
       name = "c";
       dependencies = [b];
       doC
   };
   value d = Goal {
       name = "d";
       dependencies = [c, b];
       doD
   };
   build(
       project = "My Project";
       a, b, c, d
   });
   ```
   Launching the program with goals `a, d, c` (in order) will result in the execution of `a, b, c, d` (still in order)
   """
see(`function runEngine`)
shared void build(
    "Goals and GoalSets available in the engine"
    {<Goal|GoalSet>+} goals,
    "Project name to be displayed"
    String project = "") {
    value result = runEngine(goals, project, process.arguments, consoleWriter);
    process.exit(result.exitCode);
}

"""Starts the goal engine and returns an [[EngineResult]] giving information about goals execution.
   
   All arguments passed to this program will be understood as a goal.
   Except ones starting with `"-D"` which will be understood as parameters for a goal's task.
   
   Given a list of arguments, program will look for goal names in argument list and will try to find the
   corresponding `Goal`.
   If no corresponding goal is found, an error will be raised and program will exit.
   
   For each goal found, dependencies will be linearized to ensure that if goal `a` depends on goal `b`, goal `b`
   will be executed before `a` even if only `a` was requested or if `b` was requested after `a`.
   Goals execution list will then be reduced so that a goal is only executed once during program execution.
   If goals dependencies cycle are found, an error will be raised and program will exit.
   
   Goals will be run in the order they were given to the command line, except if one goal before in the command line has
   a dependency on a later goal. In a such case, later goal will be moved before in order to maintain dependencies
   consistency.
   
   Example:
   Consider the following goals with their dependencies:
   ```ceylon
   value a = Goal {
       name = "a";
       doA
   };
   value b = Goal {
       name = "b";
       doB
   };
   value c = Goal {
       name = "c";
       dependencies = [b];
       doC
   };
   value d = Goal {
       name = "d";
       dependencies = [c, b];
       doD
   };
   build(
       project = "My Project";
       a, b, c, d
   });
   ```
   Launching the program with goals `a, d, c` (in order) will result in the execution of `a, b, c, d` (still in order)
   """
shared EngineResult runEngine(
  "Goals and GoalSets available in the engine"
  {<Goal|GoalSet>+} goals,
  "Project name to be displayed"
  String project = "",
  "Arguments given to the engine (goals names and options).
   Default value is `process.arguments`"
  [String*] arguments = process.arguments,
  "Writer to which info and error messages will be written.
   Default is to output to console."
  Writer writer = consoleWriter) {
    Integer startTime = system.milliseconds;
    writer.info("## ceylon.build: ``project``");
    {Goal+} availableGoals = mergeGoalSetsWithGoals(goals);
    value result = processGoals(availableGoals, arguments, writer);
    Integer endTime = system.milliseconds;
    String duration = "duration ``(endTime - startTime) / 1000``s";
    if (result.exitCode == exitCodes.success) {
        writer.info("## success - ``duration``");
    } else {
        writer.error("## failure - ``duration``");
    }
    return result;
}

EngineResult processGoals({Goal+} goals, [String*] arguments, Writer writer) {
    ExecutionResult executionResult;
    value invalidTasks = invalidGoalsName(goals);
    if (!invalidTasks.empty) {
        writer.error("# invalid goals found ``invalidTasks``");
        writer.error("# goal name should match following format: ```validTaskNamePattern```");
        executionResult = ExecutionResult([], [], [], exitCodes.invalidGoalFound);
    } else {
        value duplicateGoals = findDuplicateGoals(goals);
        if (duplicateGoals.empty) {
            value cycles = analyzeDependencyCycles(goals);
            if (cycles.empty) {
                value goalsToRun = buildGoalExecutionList(goals, arguments, writer).sequence;
                executionResult = runGoals(goalsToRun, arguments, goals, writer);
            } else {
                writer.error("# goal dependency cycle found between: ``cycles``");
                executionResult = ExecutionResult([], [], [], exitCodes.dependencyCycleFound);
            }
        } else {
            writer.error("# duplicate goal names found: ``duplicateGoals``");
            executionResult = ExecutionResult([], [], [], exitCodes.duplicateGoalsFound);
        }
    }
    return EngineResult {
        exitCode = executionResult.exitCode;
        availableGoals = goals.sequence;
        executionList = executionResult.toExecute;
        executed = executionResult.executed;
        failed = executionResult.failed;
        notRun = executionResult.notRun;
    };
}
