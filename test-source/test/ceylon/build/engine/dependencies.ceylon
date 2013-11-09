import ceylon.build.engine { exitCodes }
import ceylon.build.task { Goal }
import ceylon.test { test, assertEquals }

Goal a = createTestGoal("a");
Goal b = createTestGoal("b");
Goal c = createTestGoal("c");
Goal d = createTestGoal("d", [c]);
Goal e = createTestGoal("e", [b, c]);
Goal f = createTestGoal("f", [d]);

test void shouldNotFoundCycleWhenNoDependencies() {
    assertEquals(callEngine([a, b, c]), exitCodes.success);
}

test void shouldNotFoundCycleWhenNoCycle() {
    assertEquals(callEngine([a, c, d]), exitCodes.success);
    assertEquals(callEngine([f]), exitCodes.success);
    assertEquals(callEngine([b, c, e]), exitCodes.success);
    assertEquals(callEngine([c, d, f]), exitCodes.success);
    assertEquals(callEngine([a, b, c, d, e, f]), exitCodes.success);
}
