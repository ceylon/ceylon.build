import ceylon.test { assertEquals }
import ceylon.build.engine { findDuplicateGoals, invalidGoalName, invalidGoalsName }

void testDuplicateGoals() {
    assertEquals([], findDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("c")]));
    assertEquals(["b"], findDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("c"), createTestGoal("b")]));
    assertEquals(["a", "b"], findDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("b"), createTestGoal("a")]));
}

void testGoalNameValidation() {
    testValidateGoalName();
    testValidateGoalsName();
}

void testValidateGoalName() {
    assertEquals(true, invalidGoalName(""));
    assertEquals(true, invalidGoalName("0"));
    assertEquals(true, invalidGoalName("-"));
    assertEquals(true, invalidGoalName("_"));
    assertEquals(true, invalidGoalName("A"));
    assertEquals(false, invalidGoalName("a"));
    assertEquals(true, invalidGoalName("a "));
    assertEquals(true, invalidGoalName("a_"));
    assertEquals(false, invalidGoalName("ab"));
    assertEquals(false, invalidGoalName("a-b"));
    assertEquals(false, invalidGoalName("a0b"));
    assertEquals(false, invalidGoalName("a0b1"));
    assertEquals(false, invalidGoalName("compile-mod1"));
    assertEquals(true, invalidGoalName("compile_mod1"));
    assertEquals(true, invalidGoalName("compile mod1"));
}

void testValidateGoalsName() {
    value compile = createTestGoal("compile");
    value test = createTestGoal("test");
    value compileAndRun = createTestGoal("compile run");
    value compileAndTest = createTestGoal("compile_test");
    assertEquals([], invalidGoalsName({compile}));
    assertEquals([], invalidGoalsName([compile, test]));
    assertEquals([compileAndRun], invalidGoalsName([compileAndRun, test]));
    assertEquals([compileAndRun, compileAndTest], invalidGoalsName([compileAndRun, compileAndTest]));
}

