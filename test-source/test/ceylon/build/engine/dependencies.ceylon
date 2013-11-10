import ceylon.build.engine { exitCodes }
import ceylon.build.task { Goal }
import ceylon.test { test, assertEquals }

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
    assertEquals(result.exitCode, exitCodes.success);
    assertEquals(names(result.availableGoals), names(goals));
    assertEquals(execution(result), names(expectedGoalsToBeRun));
    assertEquals(success(result), names(expectedGoalsToBeRun));
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
}
