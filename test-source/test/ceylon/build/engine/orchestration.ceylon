import ceylon.build.engine { linearize, reduce, exitCodes }
import ceylon.build.task { Goal }
import ceylon.test { assertEquals, test }

test void shouldNotFindGoalToExecuteIfNoneIsRequested() {
    Goal a = createTestGoal("a");
    findGoalsToExecute([a], [], []);
}

test void shouldNotFindGoalToExecuteIfUnknownGoalIsRequested() {
    Goal a = createTestGoal("a");
    findGoalsToExecute([a], ["a", "b"], []);
}

test void shouldFindRequestedGoalToExecute() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    findGoalsToExecute([a], ["a"], [a]);
    findGoalsToExecute([a, b], ["a"], [a]);
    findGoalsToExecute([a, b], ["a", "b"], [a, b]);
    findGoalsToExecute([a, b], ["b", "a"], [b, a]);
    findGoalsToExecute([a, b], ["a", "b", "-Dfoo=bar"], [a, b]);
}

test void shouldFindRequestedGoalWithDependenciesToExecute() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b", [a]);
    findGoalsToExecute([a], ["a"], [a]);
    findGoalsToExecute([b], ["a"], []);
    findGoalsToExecute([b], ["b"], [a, b]);
    findGoalsToExecute([a, b], ["a", "b"], [a, b]);
    findGoalsToExecute([a, b], ["b", "a"], [a, b]);
}

test void testGoalsLinearization() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b", [a]);
    Goal c = createTestGoal("c", [b]);
    Goal d = createTestGoal("d", [b, a]);
    assertElementsNamesAreEquals([a], linearize(a));
    assertElementsNamesAreEquals([a, b], linearize(b));
    assertElementsNamesAreEquals([a, b, c], linearize(c));
    assertElementsNamesAreEquals([a, b, a, d], linearize(d));
}

test void testGoalsWithoutTasksLinearization() {
    Goal a = Goal("a", []);
    Goal b = Goal("b", [], [a]);
    Goal c = Goal("c", [noOp], [b]);
    Goal d = Goal("d", [noOp], [b, a]);
    assertElementsNamesAreEquals([a], linearize(a));
    assertElementsNamesAreEquals([a, b], linearize(b));
    assertElementsNamesAreEquals([a, b, c], linearize(c));
    assertElementsNamesAreEquals([a, b, a, d], linearize(d));
}

test void testGoalsWithMultipleTasksLinearization() {
    Goal a = Goal("a", [noOp, noOp]);
    Goal b = Goal("b", [noOp, noOp], [a]);
    Goal c = Goal("c", [noOp], [b]);
    Goal d = Goal("d", [noOp], [b, a]);
    assertElementsNamesAreEquals([a], linearize(a));
    assertElementsNamesAreEquals([a, b], linearize(b));
    assertElementsNamesAreEquals([a, b, c], linearize(c));
    assertElementsNamesAreEquals([a, b, a, d], linearize(d));
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

void findGoalsToExecute({Goal+} availableGoals, [String*] arguments, {Goal*} expectedExecutionList) {
    value result = callEngine(availableGoals, arguments);
    assertEquals(result.exitCode, expectedExecutionList.empty then exitCodes.noGoalToRun else exitCodes.success);
    assertEquals(names(result.availableGoals), names(availableGoals));
    assertEquals(names(result.executionList), names(expectedExecutionList));
    assertEquals(names(result.executed), names(expectedExecutionList));
    assertEquals(result.failed, []);
    assertEquals(result.notRun, []);
}
