import ceylon.build.task { Goal, Task, Context, Success, Failure, done }
import ceylon.build.engine { exitCodes }
import ceylon.test { assertEquals, assertTrue, test }
import ceylon.collection { HashMap, MutableMap }

test void testArgumentFiltering() {
    assertArgumentsAreFiltered(["a"], []);
    assertArgumentsAreFiltered(["a"], []);
    assertArgumentsAreFiltered(["a", "-D"], []);
    assertArgumentsAreFiltered(["a", "-Da"], []);
    assertArgumentsAreFiltered(["a", "-Daa"], []);
    assertArgumentsAreFiltered(["a", "-Da:"], [""]);
    assertArgumentsAreFiltered(["a", "-Da:foo"], ["foo"]);
    assertArgumentsAreFiltered(["a", "-Da:foo=bar"], ["foo=bar"]);
    assertArgumentsAreFiltered(["-Da:foo=bar", "-Da:baz=toto"], ["foo=bar", "baz=toto"]);
    assertArgumentsAreFiltered(["-Da:foo=bar", "-Db:xxx=yyy", "-Da:baz=toto"], ["foo=bar", "baz=toto"]);
}

void assertArgumentsAreFiltered({String*} inputArguments, {String*} expectedGoalArguments ) {
    Task registerArguments(String taskName, MutableMap<String, {String*}> argumentsMap) {
        return function (Context context) {
            if (argumentsMap.defines(taskName)) {
                return Failure("``taskName`` have already arguments");
            }
            argumentsMap.put(taskName, context.arguments);
            return done;
        };
    }
    value argumentsMap = HashMap<String, {String*}>();
    Goal a = Goal("a", [registerArguments("a", argumentsMap)]);
    assertEquals(callEngine([a], ["a", *inputArguments]), exitCodes.success);
    assertEquals(argumentsMap.get("a"), expectedGoalArguments);
}

test void shouldExitWithErrorWhenNoGoalToRun() {
    assertNoGoalToRun([]);
    assertNoGoalToRun(["-Da:foo"]);
}

void assertNoGoalToRun([String*] arguments) {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value writer = MockWriter();
    assertEquals(callEngine([a, b], arguments, writer), exitCodes.noGoalToRun);
    assertEquals(writer.infoMessages, ["## ceylon.build: test project"]);
    value errorMessages = writer.errorMessages.sequence;
    assertEquals(errorMessages.size, 2);
    assertEquals(errorMessages[0], "# no goal to run, available goals are: [a, b]");
    assertEquals(errorMessages[1]?.startsWith("## failure - duration "), true);
}

test void shouldExitOnTaskFailure() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = Goal("b", [(Context context) => Failure()]);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(callEngine([a, b, c, d], ["a", "b", "c", "-Da:foo"], writer), exitCodes.errorOnTaskExecution);
    assertEquals(writer.infoMessages,
        ["## ceylon.build: test project",
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"]);
    value errorMessages = writer.errorMessages.sequence;
    assertEquals(errorMessages.size, 2);
    assertEquals(errorMessages[0], "# goal b failure, stopping");
    assertEquals(errorMessages[1]?.startsWith("## failure - duration "), true);
}

test void shouldExitOnTaskError() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    function throwException(Context context) {
        throw Exception("ex");
    }
    value b = Goal("b", [throwException]);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(callEngine([a, b, c, d], ["a", "b", "c", "-Da:foo"], writer), exitCodes.errorOnTaskExecution);
    assertEquals(writer.infoMessages,
        ["## ceylon.build: test project",
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"]);
    value errorMessages = writer.errorMessages.sequence;
    assertEquals(errorMessages.size, 3);
    assertEquals(errorMessages[0], "# goal b failure, stopping");
    assertEquals(errorMessages[1], "ex");
    assertEquals(errorMessages[2]?.startsWith("## failure - duration "), true);
}

test void shouldRunGoals() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = Goal("b", [(Context context) => Success("b succeed")]);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(callEngine([a, b, c, d], ["a", "b", "c", "-Da:foo"], writer), exitCodes.success);
    value infoMessages = writer.infoMessages.sequence;
    assertEquals(infoMessages.size, 7);
    assertEquals(infoMessages[0], "## ceylon.build: test project");
    assertEquals(infoMessages[1], "# running goals: [a, b, c] in order");
    assertEquals(infoMessages[2], "# running a(foo)");
    assertEquals(infoMessages[3], "# running b()");
    assertEquals(infoMessages[4], "b succeed");
    assertEquals(infoMessages[5], "# running c()");
    assertEquals(infoMessages[6]?.startsWith("## success - duration "), true);
    assertTrue(writer.errorMessages.empty);
}
