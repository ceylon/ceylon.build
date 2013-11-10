import ceylon.build.engine { reduce, exitCodes }
import ceylon.build.task { Goal }
import ceylon.test { assertEquals, test }

test void shouldNotFindGoalToExecuteIfNoneIsRequested() {
    Goal a = createTestGoal("a");
    checkGoalsToExecute([a], [], []);
}

test void shouldNotFindGoalToExecuteIfUnknownGoalIsRequested() {
    Goal a = createTestGoal("a");
    checkGoalsToExecute([a], ["a", "b"], []);
}

test void shouldFindRequestedGoalToExecute() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    checkGoalsToExecute([a], ["a"], [a]);
    checkGoalsToExecute([a, b], ["a"], [a]);
    checkGoalsToExecute([a, b], ["a", "b"], [a, b]);
    checkGoalsToExecute([a, b], ["b", "a"], [b, a]);
    checkGoalsToExecute([a, b], ["a", "b", "-Dfoo=bar"], [a, b]);
}

test void shouldFindRequestedGoalWithDependenciesToExecute() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b", [a]);
    checkGoalsToExecute([a], ["a"], [a]);
    checkGoalsToExecute([b], ["a"], []);
    checkGoalsToExecute([b], ["b"], [a, b]);
    checkGoalsToExecute([a, b], ["a", "b"], [a, b]);
    checkGoalsToExecute([a, b], ["b", "a"], [a, b]);
}

test void testGoalsLinearization() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b", [a]);
    Goal c = createTestGoal("c", [b]);
    Goal d = createTestGoal("d", [b, a]);
    {Goal+} goals = [a, b, c, d];
    checkGoalsToExecute(goals, ["a"], [a]);
    checkGoalsToExecute(goals, ["b"], [a, b]);
    checkGoalsToExecute(goals, ["c"], [a, b, c]);
    checkGoalsToExecute(goals, ["d"], [a, b, d]);
}

test void testGoalsWithoutTasksLinearization() {
    Goal a = Goal("a", []);
    Goal b = Goal("b", [], [a]);
    Goal c = Goal("c", [noOp], [b]);
    Goal d = Goal("d", [noOp], [b, a]);
    {Goal+} goals = [a, b, c, d];
    checkGoalsToExecute(goals, ["a"], []);
    checkGoalsToExecute(goals, ["b"], []);
    checkGoalsToExecute(goals, ["c"], [c]);
    checkGoalsToExecute(goals, ["d"], [d]);
}

test void testGoalsWithMultipleTasksLinearization() {
    Goal a = Goal("a", [noOp, noOp]);
    Goal b = Goal("b", [noOp, noOp], [a]);
    Goal c = Goal("c", [noOp], [b]);
    Goal d = Goal("d", [noOp], [b, a]);
    {Goal+} goals = [a, b, c, d];
    checkGoalsToExecute(goals, ["a"], [a]);
    checkGoalsToExecute(goals, ["b"], [a, b]);
    checkGoalsToExecute(goals, ["c"], [a, b, c]);
    checkGoalsToExecute(goals, ["d"], [a, b, d]);
}

test void testGoalsReduction() {
    Goal a = Goal("a", [noOp]);
    Goal b = Goal("b", [noOp]);
    Goal c = Goal("c", [noOp]);
    assertElementsNamesAreEquals([], reduce([]));
    assertElementsNamesAreEquals([a], reduce([a]));
    assertElementsNamesAreEquals([a], reduce([a, a]));
    assertElementsNamesAreEquals([a, b], reduce([a, b]));
    assertElementsNamesAreEquals([b, a], reduce([b, a, b]));
    assertElementsNamesAreEquals([b, a, c], reduce([b, a, b, b, a, c, a, b]));
}

test void testGoalsWithMultipleTasksReduction() {
    Goal a = Goal("a", [noOp, noOp]);
    Goal b = Goal("b", [noOp]);
    assertElementsNamesAreEquals([], reduce([]));
    assertElementsNamesAreEquals([a], reduce([a]));
    assertElementsNamesAreEquals([a], reduce([a, a]));
    assertElementsNamesAreEquals([a, b], reduce([a, b]));
    assertElementsNamesAreEquals([b, a], reduce([b, a, b]));
}

test void testGoalsWithoutTasksReduction() {
    Goal a = Goal("a", []);
    Goal b = Goal("b", [noOp]);
    assertElementsNamesAreEquals([], reduce([]));
    assertElementsNamesAreEquals([], reduce([a]));
    assertElementsNamesAreEquals([], reduce([a, a]));
    assertElementsNamesAreEquals([b], reduce([a, b]));
    assertElementsNamesAreEquals([b], reduce([b, a, b]));
}

void checkGoalsToExecute({Goal+} availableGoals, [String*] arguments, {Goal*} expectedExecutionList) {
    value result = callEngine(availableGoals, arguments);
    assertEquals(result.exitCode, expectedExecutionList.empty then exitCodes.noGoalToRun else exitCodes.success);
    assertEquals(names(result.availableGoals), names(availableGoals));
    assertEquals(names(result.executionList), names(expectedExecutionList));
    assertEquals(names(result.executed), names(expectedExecutionList));
    assertEquals(result.failed, []);
    assertEquals(result.notRun, []);
}
