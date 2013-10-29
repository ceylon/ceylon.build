import ceylon.build.engine { findGoalsToExecute, linearize, reduce }
import ceylon.build.task { Goal }
import ceylon.test { assertEquals, test }

test void testFindGoalsToExecute() {
    value writer = MockWriter();
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    assertElementsNamesAreEquals([], findGoalsToExecute({ a }, [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([a], findGoalsToExecute({ a }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([], findGoalsToExecute({ a }, ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# goal 'b' not found, stopping"], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([a, b], findGoalsToExecute({ a, b }, ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([a, b], findGoalsToExecute({ a, b }, ["a", "b", "-Dfoo=bar"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([a], findGoalsToExecute({ a, b }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    Goal c = createTestGoal("c");
    Goal d = createTestGoal("d", [c]);
    assertElementsNamesAreEquals([d], findGoalsToExecute({ c, d }, ["d"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
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
