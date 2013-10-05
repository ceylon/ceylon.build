import ceylon.build.engine { analyzeDependencyCycles }
import ceylon.build.task { Goal, GoalGroup }
import ceylon.test { assertTrue }

void testDependenciesCycles() {
    shouldNotFoundCycle();
}

void shouldNotFoundCycle() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    Goal d = createTestGoal("d", [c]);
    Goal e = createTestGoal("e", [b, c]);
    Goal f = createTestGoal("f", [d]);
    GoalGroup gA = GoalGroup("gA", [d, c]);
    assertTrue(analyzeDependencyCycles({ a, c, d }).empty);
    assertTrue(analyzeDependencyCycles({ b, c, e }).empty);
    assertTrue(analyzeDependencyCycles({ c, d, f }).empty);
    assertTrue(analyzeDependencyCycles({ a, b, c, d, e, f }).empty);
    assertTrue(analyzeDependencyCycles({ a, b, c, d, e, f, gA }).empty);
}
