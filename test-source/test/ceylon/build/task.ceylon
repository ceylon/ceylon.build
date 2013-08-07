import ceylon.build { Task, Writer, createTask }
import ceylon.test { assertNotEquals, assertEquals }

Boolean noop(String[] arguments, Writer writer) => true;

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