import ceylon.build.engine { runEngine, exitCodes, EngineResult }
import ceylon.build.task { Goal, Context, Failure, done, Writer }
import ceylon.test { test, assertEquals }
import ceylon.collection { MutableList, LinkedList }

test void shouldExitWhenNoGoalToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.noGoalToRun);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), goalsToRun);
    assertEquals(success(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, []);
}

test void shouldExitWhenNoGoalWithTasksToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithoutTasks"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.noGoalToRun);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), []);
    assertEquals(success(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, []);
}

test void shouldExecuteGoalTask() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithOneTask"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.success);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), goalsToRun);
    assertEquals(success(result), goalsToRun);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, ["goalWithOneTask"]);
}

test void shouldExecuteGoalTasks() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithMultipleTasks"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.success);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), goalsToRun);
    assertEquals(success(result), goalsToRun);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, ["goalWithMultipleTasks-1", "goalWithMultipleTasks-2", "goalWithMultipleTasks-3"]);
}

test void shouldExecuteGoalTasksUntilTaskFailure() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithMultipleTasksFailingInTheMiddle"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.errorOnTaskExecution);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), goalsToRun);
    assertEquals(success(result), []);
    assertEquals(failed(result), goalsToRun);
    assertEquals(notRun(result), []);
    assertEquals(
        executedTasks,
        ["goalWithMultipleTasksFailingInTheMiddle-1", "goalWithMultipleTasksFailingInTheMiddle-2"]
    );
}

test void shouldExecuteDependenciesTasks() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithOnlyDependencies"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.success);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), ["goalWithOneTask", "goalWithMultipleTasks"]);
    assertEquals(success(result), ["goalWithOneTask", "goalWithMultipleTasks"]);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(
        executedTasks,
        ["goalWithOneTask", "goalWithMultipleTasks-1", "goalWithMultipleTasks-2", "goalWithMultipleTasks-3"]
    );
}

test void shouldExitWhenNoGoalWithTasksToRunEvenOnDependencies() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithOnlyDependenciesOnGoalsWithoutTasks"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.exitCode, exitCodes.noGoalToRun);
    assertEquals(names(result.availableGoals), availableGoals);
    assertEquals(execution(result), []);
    assertEquals(success(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, []);
}

EngineResult execute([String*] arguments, Writer writer, MutableList<String> executedTasks) {
    function createTask(String taskName) {
        return function(Context context) {
            executedTasks.add(taskName);
            return done;
        };
    }
    
    Goal goalWithoutTasks = Goal {
        name = "goalWithoutTasks";
    };
    
    Goal goalWithOneTask = Goal {
        name = "goalWithOneTask";
        createTask("goalWithOneTask")
    };
    
    Goal goalWithMultipleTasks = Goal {
        name = "goalWithMultipleTasks";
        createTask("goalWithMultipleTasks-1"),
        createTask("goalWithMultipleTasks-2"),
        createTask("goalWithMultipleTasks-3")
    };
    
    Goal goalWithMultipleTasksFailingInTheMiddle = Goal {
        name = "goalWithMultipleTasksFailingInTheMiddle";
        createTask("goalWithMultipleTasksFailingInTheMiddle-1"),
        function(Context context) {
            executedTasks.add("goalWithMultipleTasksFailingInTheMiddle-2");
            return Failure("fail to execute task 'run'");
        },
        createTask("goalWithMultipleTasksFailingInTheMiddle-3")
    };
    
    Goal goalWithOnlyDependencies = Goal {
        name = "goalWithOnlyDependencies";
        dependencies = [goalWithoutTasks, goalWithOneTask, goalWithMultipleTasks];
    };
    
    Goal goalWithOnlyDependenciesOnGoalsWithoutTasks = Goal {
        name = "goalWithOnlyDependenciesOnGoalsWithoutTasks";
        dependencies = [goalWithoutTasks];
    };
    return runEngine {
        project = "My Build Project";
        goals = [
        goalWithoutTasks, goalWithOneTask, goalWithMultipleTasks,
        goalWithMultipleTasksFailingInTheMiddle, goalWithOnlyDependencies,
        goalWithOnlyDependenciesOnGoalsWithoutTasks
        ];
        arguments = arguments;
        writer = writer;
    };
}

[String+] availableGoals = [
    "goalWithoutTasks",
    "goalWithOneTask",
    "goalWithMultipleTasks",
    "goalWithMultipleTasksFailingInTheMiddle",
    "goalWithOnlyDependencies",
    "goalWithOnlyDependenciesOnGoalsWithoutTasks"
];
