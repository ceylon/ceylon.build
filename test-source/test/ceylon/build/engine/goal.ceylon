import ceylon.test { test, assertEquals, assertNotEquals  }
import ceylon.build.engine { Goal, duplicateGoalsFound, invalidGoalFound, GoalDefinitionsBuilder }

test void testDuplicateGoals() {
    checkDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("c")], []);
    checkDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("c"), createTestGoal("b")], ["b"]);
    checkDuplicateGoals([createTestGoal("a"), createTestGoal("b"), createTestGoal("b"), createTestGoal("a")], ["a", "b"]);
}

void checkDuplicateGoals({Goal+} goals, [String*] duplicates) {
    value writer = MockWriter();
    value builder = GoalDefinitionsBuilder(goals);
    value result = callEngine(builder, [goals.first.name], writer);
    if (nonempty duplicates) {
        assertEquals(result.status, duplicateGoalsFound);
        assertEquals(writer.errorMessages.sequence[0], "# duplicate goal names found: ``duplicates``");
    } else {
        assertNotEquals(result.status, duplicateGoalsFound);
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
    checkInvalidGoalsNames([createTestGoal(name)], valid then [] else [name]);
}

void checkInvalidGoalsNames({Goal+} goals, [String*] invalidGoals) {
    value writer = MockWriter();
    value builder = GoalDefinitionsBuilder(goals);
    value result = callEngine(builder, [goals.first.name], writer);
    if (nonempty invalidGoals) {
        assertEquals(result.status, invalidGoalFound);
        assertEquals(result.definitions, null);
        assertEquals(execution(result), []);
        assertEquals(succeed(result), []);
        assertEquals(failed(result), []);
        assertEquals(notRun(result), []);
        assertEquals(writer.errorMessages.sequence[0], "# invalid goals found ``invalidGoals``");
    } else {
        assertNotEquals(result.status, invalidGoalFound);
    }
}
