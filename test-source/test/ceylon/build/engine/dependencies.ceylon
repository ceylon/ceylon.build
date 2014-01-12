import ceylon.build.task { Goal }
import ceylon.test { test, assertEquals }
import ceylon.build.engine { success }

test void shouldNotFoundCycleWhenNoDependencies() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    checkNoDependencyCycle([a, b, c]);
}

test void shouldNotFoundCycleWhenNoCycle() {
    Goal a = createTestGoal("a");
    Goal b = createTestGoal("b");
    Goal c = createTestGoal("c");
    Goal d = createTestGoal("d", [c]);
    Goal e = createTestGoal("e", [b, c]);
    Goal f = createTestGoal("f", [d]);
    checkNoDependencyCycle([a, c, d]);
    checkNoDependencyCycle([f], [c, d, f]);
    checkNoDependencyCycle([b, c, e]);
    checkNoDependencyCycle([c, d, f]);
    checkNoDependencyCycle([a, b, c, d, e, f]);
}

void checkNoDependencyCycle({Goal+} goals, {Goal+} expectedGoalsToBeRun = goals) {
    value result = callEngine(goals);
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), sort(names(goals)));
    assertEquals(execution(result), names(expectedGoalsToBeRun));
    assertEquals(succeed(result), names(expectedGoalsToBeRun));
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
}
