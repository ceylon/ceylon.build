import ceylon.build { Task, createTask, Writer }
import ceylon.test { assertNotEquals, assertEquals }

void noop(String[] arguments, Writer writer) { }

Task createTestTask(String taskName) {
    return createTask(taskName, noop);
}

void testTasks() {
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    Task aBis = createTestTask("a");
    assertEquals(a, aBis);
    assertNotEquals(a, b);
    assertNotEquals(b, aBis);
}