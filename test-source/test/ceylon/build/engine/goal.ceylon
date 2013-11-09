import ceylon.test { test, assertEquals, assertNotEquals  }
import ceylon.build.engine { invalidGoalName, invalidGoalsName, exitCodes }
import ceylon.build.task { Goal }

test void testDuplicateGoals() {
    checkDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("c")], []);
    checkDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("c"), createTestGoal("b")], ["b"]);
    checkDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("b"), createTestGoal("a")], ["a", "b"]);
}

void checkDuplicateGoals({Goal+} goals, [String*] duplicates) {
    value writer = MockWriter();
    Integer exitCode = callEngine(goals, [goals.first.name], writer);
    if (nonempty duplicates) {
        assertEquals(exitCode, exitCodes.duplicateGoalsFound);
        assertEquals(writer.errorMessages.sequence[0], "# duplicate goal names found: ``duplicates``");
    } else {
        assertNotEquals(exitCode, exitCodes.duplicateGoalsFound);
    }
}

test void testValidateGoalName() {
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

test void testValidateGoalsName() {
    value compile = createTestGoal("compile");
    value test = createTestGoal("test");
    value compileAndRun = createTestGoal("compile run");
    value compileAndTest = createTestGoal("compile_test");
    assertEquals([], invalidGoalsName({compile}));
    assertEquals([], invalidGoalsName([compile, test]));
    assertEquals([compileAndRun], invalidGoalsName([compileAndRun, test]));
    assertEquals([compileAndRun, compileAndTest], invalidGoalsName([compileAndRun, compileAndTest]));
}

