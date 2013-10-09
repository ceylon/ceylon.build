import ceylon.build.engine { findGoalsToExecute, linearize, reduce }
import ceylon.build.task { Goal, GoalGroup }
import ceylon.test { assertEquals }

void testGoalsOrchestration() {
    testFindGoalsToExecute();
    testFindGoalsWithGoalGroupsToExecute();
    testGoalsLinearization();
    testGoalsReduction();
}

void testFindGoalsToExecute() {
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

void testFindGoalsWithGoalGroupsToExecute() {
    value writer = MockWriter();
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    GoalGroup gA = GoalGroup("gA", [a, b]);
    assertElementsNamesAreEquals([a, b], findGoalsToExecute({ a, b, c, gA }, ["gA"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([b, a, b], findGoalsToExecute({ a, b, c, gA }, ["b", "gA"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertElementsNamesAreEquals([c, b, a, b], findGoalsToExecute({ a, b, c, gA }, ["c", "b", "gA"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
}

void testGoalsLinearization() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b", [a]);
    Goal c = createTestGoal("c", [b]);
    Goal d = createTestGoal("d", [b, a]);
    assertElementsNamesAreEquals([a], linearize(a));
    assertElementsNamesAreEquals([a, b], linearize(b));
    assertElementsNamesAreEquals([a, b, c], linearize(c));
    assertElementsNamesAreEquals([a, b, a, d], linearize(d));
}

void testGoalsReduction() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    assertElementsNamesAreEquals([], reduce([]));
    assertElementsNamesAreEquals([a], reduce([a]));
    assertElementsNamesAreEquals([a], reduce([a, a]));
    assertElementsNamesAreEquals([a, b], reduce([a, b]));
    assertElementsNamesAreEquals([b, a], reduce([b, a, b]));
    assertElementsNamesAreEquals([b, a, c], reduce([b, a, b, b, a, c, a, b]));
}