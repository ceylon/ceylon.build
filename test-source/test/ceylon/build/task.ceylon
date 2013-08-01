import ceylon.build { Task }
import ceylon.test { assertNotEquals, assertEquals }

void noop(String[] arguments) { }

Task createTask(String taskName, void processTask(String[] arguments) => noop(arguments)) {
    object task satisfies Task {
        shared actual String name = taskName;
        shared actual void process(String[] arguments) => processTask(arguments);
    }
    return task;
}

void testTasks() {
    Task a = createTask("a");
    Task b = createTask("b");
    Task aBis = createTask("a");
    assertEquals(a, aBis);
    assertNotEquals(a, b);
    assertNotEquals(b, aBis);
}