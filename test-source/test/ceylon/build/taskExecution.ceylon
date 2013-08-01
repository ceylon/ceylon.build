import ceylon.build { Task, filterArgumentsForTask }
import ceylon.test { assertEquals }

void testTasksExecution() {
    testArgumentFiltering();
}
void testArgumentFiltering() {
    Task a = createTask("a");
    assertEquals([], filterArgumentsForTask(a, []));
    assertEquals([], filterArgumentsForTask(a, ["clean", "compile"]));
    assertEquals([], filterArgumentsForTask(a, ["clean", "compile", "-D"]));
    assertEquals([], filterArgumentsForTask(a, ["clean", "compile", "-Da"]));
    assertEquals([], filterArgumentsForTask(a, ["clean", "compile", "-Daa"]));
    assertEquals([""], filterArgumentsForTask(a, ["clean", "compile", "-Da:"]));
    assertEquals(["foo"], filterArgumentsForTask(a, ["clean", "compile", "-Da:foo"]));
    assertEquals(["foo=bar"], filterArgumentsForTask(a, ["clean", "compile", "-Da:foo=bar"]));
    assertEquals(["foo=bar", "baz=toto"], filterArgumentsForTask(a, ["clean", "compile", "-Da:foo=bar", "-Da:baz=toto"]));
    assertEquals(["foo=bar", "baz=toto"], filterArgumentsForTask(a, ["clean", "compile", "-Da:foo=bar", "-Db:xxx=yyy", "-Da:baz=toto"]));
}