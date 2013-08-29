import ceylon.test { assertEquals }
import ceylon.build.engine { findDuplicateTasks, invalidTaskName, invalidTasksName }

void testDuplicateTasks() {
    assertEquals([], findDuplicateTasks([createTestTask("a"), createTestTask("b"), createTestTask("c")]));
    assertEquals(["b"], findDuplicateTasks([createTestTask("a"), createTestTask("b"), createTestTask("c"), createTestTask("b")]));
    assertEquals(["a", "b"], findDuplicateTasks([createTestTask("a"), createTestTask("b"), createTestTask("b"), createTestTask("a")]));
}

void testTasksNameValidation() {
    testValidateTaskName();
    testValidateTasksName();
}

void testValidateTaskName() {
    assertEquals(true, invalidTaskName(""));
    assertEquals(true, invalidTaskName("0"));
    assertEquals(true, invalidTaskName("-"));
    assertEquals(true, invalidTaskName("_"));
    assertEquals(true, invalidTaskName("A"));
    assertEquals(false, invalidTaskName("a"));
    assertEquals(true, invalidTaskName("a "));
    assertEquals(true, invalidTaskName("a_"));
    assertEquals(false, invalidTaskName("ab"));
    assertEquals(false, invalidTaskName("a-b"));
    assertEquals(false, invalidTaskName("a0b"));
    assertEquals(false, invalidTaskName("a0b1"));
    assertEquals(false, invalidTaskName("compile-mod1"));
    assertEquals(true, invalidTaskName("compile_mod1"));
    assertEquals(true, invalidTaskName("compile mod1"));
}

void testValidateTasksName() {
    value compile = createTestTask("compile");
    value test = createTestTask("test");
    value compileAndRun = createTestTask("compile run");
    value compileAndTest = createTestTask("compile_test");
    assertEquals([], invalidTasksName({compile}));
    assertEquals([], invalidTasksName([compile, test]));
    assertEquals([compileAndRun], invalidTasksName([compileAndRun, test]));
    assertEquals([compileAndRun, compileAndTest], invalidTasksName([compileAndRun, compileAndTest]));
}

