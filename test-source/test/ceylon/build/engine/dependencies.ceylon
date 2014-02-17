import ceylon.test { test, assertEquals }
import ceylon.build.engine { Goal, success, GoalDefinitionsBuilder }

test void shouldNotFoundCycleWhenNoDependencies() {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    checkNoDependencyCycle([a, b, c]);
}

test void shouldNotFoundCycleWhenNoCycle() {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value d = createTestGoal("d", ["c"]);
    value e = createTestGoal("e", ["b", "c"]);
    value f = createTestGoal("f", ["d"]);
    //checkNoDependencyCycle([a, c, d]);
    //checkNoDependencyCycle([f], [c, d, f]);
    //checkNoDependencyCycle([b, c, e]);
    //checkNoDependencyCycle([c, d, f]);
    checkNoDependencyCycle([a, b, c, d, e, f]);
}

void checkNoDependencyCycle({Goal+} goals, {Goal+} expectedGoalsToBeRun = goals) {
    value builder = GoalDefinitionsBuilder(goals);
    value result = callEngine(builder, names(goals));
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), sort(names(goals)));
    assertEquals(execution(result), names(expectedGoalsToBeRun));
    assertEquals(succeed(result), names(expectedGoalsToBeRun));
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
}
