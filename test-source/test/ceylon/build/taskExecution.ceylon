import ceylon.build { Task, Builder }
import ceylon.test { assertEquals }

void testTasksExecution() {
    testArgumentFiltering();
}
void testArgumentFiltering() {
    Task a = createTask("a");
    assertEquals([], Builder().filterArgumentsForTask(a, []));
    assertEquals([], Builder().filterArgumentsForTask(a, ["clean", "compile"]));
    assertEquals([], Builder().filterArgumentsForTask(a, ["clean", "compile", "-D"]));
    assertEquals([], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Da"]));
    assertEquals([], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Daa"]));
    assertEquals([""], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Da:"]));
    assertEquals(["foo"], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Da:foo"]));
    assertEquals(["foo=bar"], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Da:foo=bar"]));
    assertEquals(["foo=bar", "baz=toto"], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Da:foo=bar", "-Da:baz=toto"]));
    assertEquals(["foo=bar", "baz=toto"], Builder().filterArgumentsForTask(a, ["clean", "compile", "-Da:foo=bar", "-Db:xxx=yyy", "-Da:baz=toto"]));
}