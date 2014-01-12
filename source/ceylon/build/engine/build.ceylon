import ceylon.build.task { HardCodedGoal = Goal, GoalSet, Writer }
import ceylon.collection { HashSet, MutableSet }

"""Starts the goal engine and exits with exit code 0 in case of success and 1 in case of failure.
   
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
deprecated("Prefer declarative over imperative build syntax")
shared void build(
    "Goals and GoalSets available in the engine"
    {<HardCodedGoal|GoalSet>+} goals,
    "Project name to be displayed"
    String project = "") {
    value result = runEngine(goals, project, process.arguments, consoleWriter);
    process.exit(result.status == success then 0 else 1);
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
deprecated("Prefer declarative over imperative build syntax")
shared EngineResult runEngine(
  "Goals and GoalSets available in the engine"
  {<HardCodedGoal|GoalSet>+} goals,
  "Project name to be displayed"
  String project = "",
  "Arguments given to the engine (goals names and options).
   Default value is `process.arguments`"
  [String*] arguments = process.arguments,
  "Writer to which info and error messages will be written.
   Default is to output to console."
  Writer writer = consoleWriter) {
    {HardCodedGoal+} availableGoals = mergeGoalSetsWithGoals(goals);
    value alreadyImportedGoals = HashSet<String>();
    GoalDefinitionsBuilder map = GoalDefinitionsBuilder();
    for (goal in availableGoals) {
        map.add(toGoalDefinition(goal, false));
        alreadyImportedGoals.add(goal.name);
    }
    for (goal in availableGoals) {
        addInternalGoal(goal, map, alreadyImportedGoals);
    }
    return runEngineFromDefinitions(map, project, arguments, writer);
}

Goal toGoalDefinition(HardCodedGoal goal, Boolean internal) {
    return Goal(goal.name, GoalProperties(internal, goal.tasks, [ for (g in goal.dependencies) g.name ]));
}

void addInternalGoal(HardCodedGoal goal, GoalDefinitionsBuilder map, MutableSet<String> alreadyImportedGoals) {
    for (dependency in goal.dependencies) {
        value name = dependency.name;
        if (!alreadyImportedGoals.contains(name)) {
            map.add(toGoalDefinition(dependency, true));
            alreadyImportedGoals.add(dependency.name);
            addInternalGoal(dependency, map, alreadyImportedGoals);
        }
    }
}

shared EngineResult runEngineFromDefinitions(
    "Goals available in the engine"
    GoalDefinitionsBuilder|GoalDefinitions goals,
    "Project name to be displayed"
    String project = "",
    "Arguments given to the engine (goals names and options).
     Default value is `process.arguments`"
    [String*] arguments = process.arguments,
    "Writer to which info and error messages will be written.
     Default is to output to console."
    Writer writer = consoleWriter) {
    Integer startTime = system.milliseconds;
    if (goals is GoalDefinitionsBuilder) {
        writer.info("## ceylon.build: ``project``");
    }
    value result = processGoals(goals, arguments, writer);
    Integer endTime = system.milliseconds;
    String duration = "duration ``(endTime - startTime) / 1000``s";
    if (result.status == success) {
        writer.info("## success - ``duration``");
    } else {
        writer.error("## failure - ``duration``");
    }
    return result;
}

EngineResult processGoals(GoalDefinitionsBuilder|GoalDefinitions goals, [String*] arguments, Writer writer) {
    GoalDefinitions definitions;
    switch (goals)
    case (is GoalDefinitionsBuilder) {
        value definitionValidationResult = goals.validate();
        if (!definitionValidationResult.valid) {
            value status = reportInvalidDefinitions(definitionValidationResult, writer);
            return EngineResult(definitionValidationResult.definitions, [], status);
        } else {
            assert(exists defs = definitionValidationResult.definitions);
            definitions = defs;
        }
    } case (is GoalDefinitions) {
        definitions = goals;
    }
    value goalsToRun = buildGoalExecutionList(definitions, arguments, writer).sequence;
    value result = runGoals(goalsToRun, arguments, definitions, writer);
    return EngineResult(definitions, result.executionResults, result.status);
}
