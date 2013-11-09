import ceylon.build.engine { runEngine, exitCodes }
import ceylon.build.task { Goal, Context, Failure, done, Writer }
import ceylon.test { test, assertEquals }
import ceylon.collection { MutableList, LinkedList }

Integer execute([String*] arguments, Writer writer, MutableList<String> executedTasks) {
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

test void shouldExitWhenNoGoalToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute([], writer, executedTasks);
    assertEquals(exitCodes.noGoalToRun, exitCode);
    assertEquals([], executedTasks);
}

test void shouldExitWhenNoGoalWithTasksToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute(["goalWithoutTasks"], writer, executedTasks);
    assertEquals(exitCodes.noGoalToRun, exitCode);
    assertEquals([], executedTasks);
}

test void shouldExecuteGoalTask() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute(["goalWithOneTask"], writer, executedTasks);
    assertEquals(exitCodes.success, exitCode);
    assertEquals(["goalWithOneTask"], executedTasks);
}

test void shouldExecuteGoalTasks() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute(["goalWithMultipleTasks"], writer, executedTasks);
    assertEquals(exitCodes.success, exitCode);
    assertEquals(["goalWithMultipleTasks-1", "goalWithMultipleTasks-2", "goalWithMultipleTasks-3"], executedTasks);
}

test void shouldExecuteGoalTasksUntilTaskFailure() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute(["goalWithMultipleTasksFailingInTheMiddle"], writer, executedTasks);
    assertEquals(exitCodes.errorOnTaskExecution, exitCode);
    assertEquals(
        ["goalWithMultipleTasksFailingInTheMiddle-1", "goalWithMultipleTasksFailingInTheMiddle-2"],
        executedTasks
    );
}

test void shouldExecuteDependenciesTasks() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute(["goalWithOnlyDependencies"], writer, executedTasks);
    assertEquals(exitCodes.success, exitCode);
    assertEquals(
        ["goalWithOneTask", "goalWithMultipleTasks-1", "goalWithMultipleTasks-2", "goalWithMultipleTasks-3"],
        executedTasks
    );
}

test void shouldExitWhenNoGoalWithTasksToRunEvenOnDependencies() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    Integer exitCode = execute(["goalWithOnlyDependenciesOnGoalsWithoutTasks"], writer, executedTasks);
    assertEquals(exitCodes.noGoalToRun, exitCode);
    assertEquals([], executedTasks);
}
