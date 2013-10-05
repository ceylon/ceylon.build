import ceylon.build.task { Goal, Task, Context }
import ceylon.build.engine { filterArgumentsForGoal, runGoals, exitCode }
import ceylon.test { assertEquals, assertTrue }

void testGoalsExecution() {
    testArgumentFiltering();
    testRunGoals();
}
void testArgumentFiltering() {
    Goal a = createTestGoal("a");
    assertEquals([], filterArgumentsForGoal(a, []));
    assertEquals([], filterArgumentsForGoal(a, ["clean", "compile"]));
    assertEquals([], filterArgumentsForGoal(a, ["clean", "compile", "-D"]));
    assertEquals([], filterArgumentsForGoal(a, ["clean", "compile", "-Da"]));
    assertEquals([], filterArgumentsForGoal(a, ["clean", "compile", "-Daa"]));
    assertEquals([""], filterArgumentsForGoal(a, ["clean", "compile", "-Da:"]));
    assertEquals(["foo"], filterArgumentsForGoal(a, ["clean", "compile", "-Da:foo"]));
    assertEquals(["foo=bar"], filterArgumentsForGoal(a, ["clean", "compile", "-Da:foo=bar"]));
    assertEquals(["foo=bar", "baz=toto"], filterArgumentsForGoal(a, ["clean", "compile", "-Da:foo=bar", "-Da:baz=toto"]));
    assertEquals(["foo=bar", "baz=toto"], filterArgumentsForGoal(a, ["clean", "compile", "-Da:foo=bar", "-Db:xxx=yyy", "-Da:baz=toto"]));
}

void testRunGoals() {
    shouldExitWithErrorWhenNoGoalToRun();
    shouldExitOnTaskFailure();
    shouldExitOnTaskError();
    shouldRunGoals();
}

void shouldExitWithErrorWhenNoGoalToRun() {
    value writer = MockWriter();
    assertEquals(exitCode.noGoalToRun, runGoals([], [], [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# no goal to run, available goals are: []"], writer.errorMessages);
    writer.clear();
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    assertEquals(exitCode.noGoalToRun, runGoals([], ["-Da:foo"], [a, b], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# no goal to run, available goals are: [a, b]"], writer.errorMessages);
}

void shouldExitOnTaskFailure() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = Goal("b", (Context context) => false);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(exitCode.errorOnTaskExecution, runGoals([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"], writer.infoMessages);
    assertEquals(["# goal b failure, stopping"], writer.errorMessages);
}

void shouldExitOnTaskError() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    Task throwException = function(Context context) { 
        throw Exception("ex");
    };
    value b = Goal("b", throwException);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(exitCode.errorOnTaskExecution, runGoals([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"], writer.infoMessages);
    assertEquals(2, writer.errorMessages.size);
    assertEquals("# error during goal execution b, stopping", writer.errorMessages.first);
}

void shouldRunGoals(){
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(exitCode.success, runGoals([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()",
        "# running c()"], writer.infoMessages);
    assertTrue(writer.errorMessages.empty);
}