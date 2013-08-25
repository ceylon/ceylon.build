import ceylon.build { Task, filterArgumentsForTask, runTasks, Writer, TaskDefinition, Context, exitCode }
import ceylon.test { assertEquals, assertTrue }

void testTasksExecution() {
    testArgumentFiltering();
    testRunTasks();
}
void testArgumentFiltering() {
    Task a = createTestTask("a");
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

void testRunTasks() {
    shouldExitWithErrorWhenNoTasksToRun();
    shouldExitOnTaskFailure();
    shouldExitOnTaskError();
    shouldRunTasks();
}

void shouldExitWithErrorWhenNoTasksToRun() {
    value writer = MockWriter();
    assertEquals(exitCode.noTaskToRun, runTasks([], [], [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# no task to run, available tasks are: []"], writer.errorMessages);
    writer.clear();
    value a = createTestTask("a");
    value b = createTestTask("b");
    assertEquals(exitCode.noTaskToRun, runTasks([], ["-Da:foo"], [a, b], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# no task to run, available tasks are: [a, b]"], writer.errorMessages);
}

void shouldExitOnTaskFailure() {
    value writer = MockWriter();
    value a = createTestTask("a");
    value b = Task("b", (Context context) => false);
    value c = createTestTask("c");
    value d = createTestTask("d");
    assertEquals(exitCode.errorOnTaskExecution, runTasks([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running tasks: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"], writer.infoMessages);
    assertEquals(["# task b failure, stopping"], writer.errorMessages);
}

void shouldExitOnTaskError() {
    value writer = MockWriter();
    value a = createTestTask("a");
    TaskDefinition throwException = function(Context context) { 
        throw Exception("ex");
    };
    value b = Task("b", throwException);
    value c = createTestTask("c");
    value d = createTestTask("d");
    assertEquals(exitCode.errorOnTaskExecution, runTasks([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running tasks: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"], writer.infoMessages);
    assertEquals(2, writer.errorMessages.size);
    assertEquals("# error during task execution b, stopping", writer.errorMessages.first);
}

void shouldRunTasks(){
    value writer = MockWriter();
    value a = createTestTask("a");
    value b = createTestTask("b");
    value c = createTestTask("c");
    value d = createTestTask("d");
    assertEquals(exitCode.success, runTasks([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running tasks: [a, b, c] in order",
        "# running a(foo)",
        "# running b()",
        "# running c()"], writer.infoMessages);
    assertTrue(writer.errorMessages.empty);
}
