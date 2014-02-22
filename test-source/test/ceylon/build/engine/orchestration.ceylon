import ceylon.build.engine { Goal, success, noGoalToRun, GoalDefinitionsBuilder, runEngine, Status  }
import ceylon.test { test }

test void shouldNotFindGoalToExecuteIfNoneIsRequested() {
    value a = createTestGoal("a");
    checkGoalsToExecute([a], [], []);
}

test void shouldNotFindGoalToExecuteIfUnknownGoalIsRequested() {
    value a = createTestGoal("a");
    value writer = MockWriter();
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder([a]);
            arguments = ["a", "b"];
            writer = writer;
        };
        status = noGoalToRun;
        available = ["a"];
        toRun = [];
        successful = [];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage];
        errorMessages = ["# goal 'b' not found, stopping", "# no goal to run, available goals are: [a]"];
    };
}

test void shouldFindRequestedGoalToExecute() {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    checkGoalsToExecute([a], ["a"], [a]);
    checkGoalsToExecute([a, b], ["a"], [a]);
    checkGoalsToExecute([a, b], ["a", "b"], [a, b]);
    checkGoalsToExecute([a, b], ["b", "a"], [b, a]);
    checkGoalsToExecute([a, b], ["a", "b", "-Dfoo=bar"], [a, b]);
}

test void shouldFindRequestedGoalWithDependenciesToExecute() {
    value a = createTestGoal("a");
    value b = createTestGoal("b", ["a"]);
    checkGoalsToExecute([a], ["a"], [a]);
    checkGoalsToExecute([a, b], ["a"], [a]);
    checkGoalsToExecute([a, b], ["b"], [a, b]);
    checkGoalsToExecute([a, b], ["a", "b"], [a, b]);
    checkGoalsToExecute([a, b], ["b", "a"], [a, b]);
}

test void testGoalsLinearization() {
    value a = createTestGoal("a");
    value b = createTestGoal("b", ["a"]);
    value c = createTestGoal("c", ["b"]);
    value d = createTestGoal("d", ["b", "a"]);
    value goals = [a, b, c, d];
    checkGoalsToExecute(goals, ["a"], [a]);
    checkGoalsToExecute(goals, ["b"], [a, b]);
    checkGoalsToExecute(goals, ["c"], [a, b, c]);
    checkGoalsToExecute(goals, ["d"], [a, b, d]);
}

test void testGoalsWithoutTasksLinearization() {
    value a = createTestGoal("a", [], null);
    value b = createTestGoal("b", ["a"], null);
    value c = createTestGoal("c", ["b"]);
    value d = createTestGoal("d", ["b", "a"]);
    value goals = [a, b, c, d];
    checkGoalsToExecute(goals, ["a"], []);
    checkGoalsToExecute(goals, ["b"], []);
    checkGoalsToExecute(goals, ["c"], [c]);
    checkGoalsToExecute(goals, ["d"], [d]);
}

test void testGoalsWithMultipleTasksLinearization() {
    value a = createTestGoal("a");
    value b = createTestGoal("b", ["a"]);
    value c = createTestGoal("c", ["b"]);
    value d = createTestGoal("d", ["b", "a"]);
    value goals = [a, b, c, d];
    checkGoalsToExecute(goals, ["a"], [a]);
    checkGoalsToExecute(goals, ["b"], [a, b]);
    checkGoalsToExecute(goals, ["c"], [a, b, c]);
    checkGoalsToExecute(goals, ["d"], [a, b, d]);
}

test void testGoalsReduction() {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value goals = [a, b, c];
    checkGoalsToExecute(goals, [], []);
    checkGoalsToExecute(goals, ["a"], [a]);
    checkGoalsToExecute(goals, ["a", "a"], [a]);
    checkGoalsToExecute(goals, ["a", "b"], [a, b]);
    checkGoalsToExecute(goals, ["b", "a"], [b, a]);
    checkGoalsToExecute(goals, ["b", "a", "b"], [b, a]);
    checkGoalsToExecute(goals, ["b", "a", "b", "b", "a", "c", "a", "b"], [b, a, c]);
}

test void testGoalsWithMultipleTasksReduction() {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value goals = [a, b];
    checkGoalsToExecute(goals, [], []);
    checkGoalsToExecute(goals, ["a"], [a]);
    checkGoalsToExecute(goals, ["a", "a"], [a]);
    checkGoalsToExecute(goals, ["a", "b"], [a, b]);
    checkGoalsToExecute(goals, ["b", "a"], [b, a]);
    checkGoalsToExecute(goals, ["b", "a", "b"], [b, a]);
}

test void testGoalsWithoutTasksReduction() {
    value a = createTestGoal("a", [], null);
    value b = createTestGoal("b");
    value goals = [a, b];
    checkGoalsToExecute(goals, [], []);
    checkGoalsToExecute(goals, ["a"], []);
    checkGoalsToExecute(goals, ["a", "a"], []);
    checkGoalsToExecute(goals, ["a", "b"], [b]);
    checkGoalsToExecute(goals, ["b", "a"], [b]);
    checkGoalsToExecute(goals, ["b", "a", "b"], [b]);
}

void checkGoalsToExecute([Goal*] availableGoals, [String*] arguments, [Goal*] expectedExecutionList) {
    value writer = MockWriter();
    value toRun = names(expectedExecutionList);
    value availableGoalsSorted = sort(names(availableGoals));
    Status status;
    [String*] infoMessages;
    [String*] errorMessages;
    if (expectedExecutionList.empty) {
        status = noGoalToRun;
        infoMessages = [ceylonBuildStartMessage];
        errorMessages = ["# no goal to run, available goals are: ``availableGoalsSorted``"];
    } else {
        status = success;
        infoMessages = concatenate(
            [ceylonBuildStartMessage, "# running goals: ``toRun`` in order"],
            [ for (goal in toRun) "# running ``goal``()"]);
        errorMessages = [];
    }
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder(availableGoals);
            arguments = arguments;
            writer = writer;
        };
        status = status;
        available = availableGoalsSorted;
        toRun = toRun;
        successful = toRun;
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = infoMessages;
        errorMessages = errorMessages;
    };
}
