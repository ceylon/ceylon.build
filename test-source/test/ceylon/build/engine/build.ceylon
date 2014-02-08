import ceylon.build.engine { runEngine, EngineResult, noGoalToRun, errorOnTaskExecution, success, GoalDefinitionsBuilder, Goal, GoalProperties }
import ceylon.build.task { Writer, noop }
import ceylon.test { test, assertEquals }
import ceylon.collection { MutableList, LinkedList }

test void shouldExitWhenNoGoalToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.status, noGoalToRun);
    assertEquals(definitionsNames(result), sort(availableGoals));
    assertEquals(execution(result), goalsToRun);
    assertEquals(succeed(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, []);
}

test void shouldExitWhenNoGoalWithTasksToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithoutTasks"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.status, noGoalToRun);
    assertEquals(definitionsNames(result), sort(availableGoals));
    assertEquals(execution(result), []);
    assertEquals(succeed(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, []);
}

test void shouldExecuteGoalTask() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithOneTask"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), sort(availableGoals));
    assertEquals(execution(result), goalsToRun);
    assertEquals(succeed(result), goalsToRun);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, ["goalWithOneTask"]);
}

test void shouldExecuteGoalTasks() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithMultipleTasks"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), availableGoals);
    assertEquals(execution(result), goalsToRun);
    assertEquals(succeed(result), goalsToRun);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, ["goalWithMultipleTasks-1", "goalWithMultipleTasks-2", "goalWithMultipleTasks-3"]);
}

test void shouldExecuteGoalTasksUntilTaskFailure() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = ["goalWithMultipleTasksFailingInTheMiddle"];
    value result = execute(goalsToRun, writer, executedTasks);
    assertEquals(result.status, errorOnTaskExecution);
    assertEquals(definitionsNames(result), availableGoals);
    assertEquals(execution(result), goalsToRun);
    assertEquals(succeed(result), []);
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
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), availableGoals);
    assertEquals(execution(result), ["goalWithOneTask", "goalWithMultipleTasks"]);
    assertEquals(succeed(result), ["goalWithOneTask", "goalWithMultipleTasks"]);
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
    assertEquals(result.status, noGoalToRun);
    assertEquals(definitionsNames(result), availableGoals);
    assertEquals(execution(result), []);
    assertEquals(succeed(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(executedTasks, []);
}

EngineResult execute([String*] arguments, Writer writer, MutableList<String> executedTasks) {
    value builder = GoalDefinitionsBuilder();
    builder.add {
        Goal {
            name = "goalWithoutTasks";
            properties = GoalProperties {
                internal = false;
                task = noop;
                dependencies = [];
            };
        };
    };
    builder.add {
        Goal {
            name = "goalWithOneTask";
            properties = GoalProperties {
                internal = false;
                task = () => executedTasks.add("goalWithOneTask");
                dependencies = [];
            };
        };
    };
    builder.add {
        Goal {
            name = "goalWithMultipleTasks";
            properties = GoalProperties {
                internal = false;
                task = void() {
                    executedTasks.add("goalWithMultipleTasks-1");
                    executedTasks.add("goalWithMultipleTasks-2");
                    executedTasks.add("goalWithMultipleTasks-3");
                };
                dependencies = [];
            };
        };
    };
    builder.add {
        Goal {
            name = "goalWithMultipleTasksFailingInTheMiddle";
            properties = GoalProperties {
                internal = false;
                task = void() {
                    executedTasks.add("goalWithMultipleTasksFailingInTheMiddle-1");
                    executedTasks.add("goalWithMultipleTasksFailingInTheMiddle-2");
                    "fail to execute task 'run'"
                    assert(1 == 0);
                    executedTasks.add("goalWithMultipleTasksFailingInTheMiddle-3");
                };
                dependencies = [];
            };
        };
    };
    builder.add {
        Goal {
            name = "goalWithOnlyDependencies";
            properties = GoalProperties {
                internal = false;
                task = noop;
                dependencies = ["goalWithoutTasks","goalWithOneTask","goalWithMultipleTasks"];
            };
        };
    };
    builder.add {
        Goal {
            name = "goalWithOnlyDependenciesOnGoalsWithoutTasks";
            properties = GoalProperties {
                internal = false;
                task = noop;
                dependencies = ["goalWithoutTasks"];
            };
        };
    };
    return runEngine {
        goals = builder;
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
