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
    assertEquals([], findGoalsToExecute({ a }, [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findGoalsToExecute({ a }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([], findGoalsToExecute({ a }, ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# goal 'b' not found, stopping"], writer.errorMessages);
    writer.clear();
    assertEquals([a, b], findGoalsToExecute({ a, b }, ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a, b], findGoalsToExecute({ a, b }, ["a", "b", "-Dfoo=bar"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findGoalsToExecute({ a, b }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    Goal c = createTestGoal("c");
    Goal d = createTestGoal("d", [c]);
    assertEquals([d], findGoalsToExecute({ c, d }, ["d"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
}

void testFindGoalsWithGoalGroupsToExecute() {
    value writer = MockWriter();
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    GoalGroup gA = GoalGroup("gA", [a, b]);
    assertEquals([a, b], findGoalsToExecute({ a, b, c, gA }, ["gA"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([b, a, b], findGoalsToExecute({ a, b, c, gA }, ["b", "gA"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([c, b, a, b], findGoalsToExecute({ a, b, c, gA }, ["c", "b", "gA"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
}

void testGoalsLinearization() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b", [a]);
    Goal c = createTestGoal("c", [b]);
    Goal d = createTestGoal("d", [b, a]);
    assertEquals([a], linearize(a));
    assertEquals([a, b], linearize(b));
    assertEquals([a, b, c], linearize(c));
    assertEquals([a, b, a, d], linearize(d));
}

void testGoalsReduction() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    assertEquals([], reduce([]));
    assertEquals([a], reduce([a]));
    assertEquals([a], reduce([a, a]));
    assertEquals([a, b], reduce([a, b]));
    assertEquals([b, a], reduce([b, a, b]));
    assertEquals([b, a, c], reduce([b, a, b, b, a, c, a, b]));
}