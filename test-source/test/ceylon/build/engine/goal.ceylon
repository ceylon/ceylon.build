import ceylon.test { test, assertEquals, assertNotEquals  }
import ceylon.build.engine { exitCodes }
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
    checkGoalName("", false);
    checkGoalName("0", false);
    checkGoalName("00", false);
    checkGoalName("0a0", false);
    checkGoalName("0aa", false);
    checkGoalName("-", false);
    checkGoalName("-a", false);
    checkGoalName("_", false);
    checkGoalName("_A", false);
    checkGoalName("A", false);
    checkGoalName("a", true);
    checkGoalName("a", true);
    checkGoalName("a_", false);
    checkGoalName("ab", true);
    checkGoalName("a-b", true);
    checkGoalName("a0b", true);
    checkGoalName("a0b1", true);
    checkGoalName("compile-mod1", true);
    checkGoalName("compile-mod1", true);
    checkGoalName("compile_mod1", false);
    checkGoalName("compile mod1", false);
}

test void testValidateGoalsName() {
    value compile = createTestGoal("compile");
    value test = createTestGoal("test");
    value compileAndRun = createTestGoal("compile run");
    value compileAndTest = createTestGoal("compile_test");
    checkInvalidGoalsNames([compile], []);
    checkInvalidGoalsNames([compile, test], []);
    checkInvalidGoalsNames([compileAndRun, test], ["compile run"]);
    checkInvalidGoalsNames([compileAndRun, compileAndTest], ["compile run", "compile_test"]);
}

void checkGoalName(String name, Boolean valid) {
    checkInvalidGoalsNames([Goal(name)], valid then [] else [name]);
}

void checkInvalidGoalsNames({Goal+} goals, [String*] invalidGoals) {
    value writer = MockWriter();
    Integer exitCode = callEngine(goals, [goals.first.name], writer);
    if (nonempty invalidGoals) {
        assertEquals(exitCode, exitCodes.invalidGoalFound);
        assertEquals(writer.errorMessages.sequence[0], "# invalid goals found ``invalidGoals``");
    } else {
        assertNotEquals(exitCode, exitCodes.invalidGoalFound);
    }
}
