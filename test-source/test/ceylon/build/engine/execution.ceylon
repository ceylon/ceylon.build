import ceylon.build.task { context }
import ceylon.build.engine { errorOnTaskExecution, success, noGoalToRun }
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

void assertArgumentsAreFiltered([String*] inputArguments, [String*] expectedGoalArguments ) {
    Anything() registerArguments(String taskName, MutableMap<String, [String*]> argumentsMap) {
        return void() {
            if (argumentsMap.defines(taskName)) {
                throw AssertionException("``taskName`` have already arguments");
            }
            argumentsMap.put(taskName, context.arguments);
        };
    }
    value argumentsMap = HashMap<String, [String*]>();
    value goalNameA = "a";
    value a = createTestGoal(goalNameA, [], registerArguments(goalNameA, argumentsMap));
    value goals = [a];
    value builder = builderFromGoals(goals);
    value result = callEngine(builder, [goalNameA, *inputArguments]);
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), names([a]));
    assertEquals(execution(result), [goalNameA]);
    assertEquals(succeed(result), [goalNameA]);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(argumentsMap.get(goalNameA), expectedGoalArguments);
}

test void shouldExitWithErrorWhenNoGoalToRun() {
    assertNoGoalToRun([]);
    assertNoGoalToRun(["-Da:foo"]);
}

void assertNoGoalToRun([String*] arguments) {
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value writer = MockWriter();
    value goals = [a, b];
    value builder = builderFromGoals(goals);
    value result = callEngine(builder, arguments, writer);
    assertEquals(result.status, noGoalToRun);
    assertEquals(definitionsNames(result), names(goals));
    assertEquals(execution(result), []);
    assertEquals(succeed(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(writer.infoMessages, ["## ceylon.build"]);
    value errorMessages = writer.errorMessages.sequence;
    assertEquals(errorMessages.size, 2);
    assertEquals(errorMessages[0], "# no goal to run, available goals are: [a, b]");
    assertEquals(errorMessages[1]?.startsWith("## failure - duration "), true);
}

test void shouldExitOnTaskError() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    function throwException() {
        throw Exception("ex");
    }
    value b = createTestGoal("b", [], throwException);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    value goals = [a, b, c, d];
    value builder = builderFromGoals(goals);
    value result = callEngine(builder, ["a", "b", "c", "-Da:foo"], writer);
    assertEquals(result.status, errorOnTaskExecution);
    assertEquals(definitionsNames(result), names(goals));
    assertEquals(execution(result), ["a", "b", "c"]);
    assertEquals(succeed(result), ["a"]);
    assertEquals(failed(result), ["b"]);
    assertEquals(notRun(result), ["c"]);
    assertEquals(writer.infoMessages,
        ["## ceylon.build",
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
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    value goals = [a, b, c, d];
    value builder = builderFromGoals(goals);
    value result = callEngine(builder, ["a", "b", "c", "-Da:foo"], writer);
    assertEquals(result.status, success);
    assertEquals(definitionsNames(result), names(goals));
    assertEquals(execution(result), ["a", "b", "c"]);
    assertEquals(succeed(result), ["a", "b", "c"]);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    value infoMessages = writer.infoMessages.sequence;
    assertEquals(infoMessages.size, 6);
    assertEquals(infoMessages[0], "## ceylon.build");
    assertEquals(infoMessages[1], "# running goals: [a, b, c] in order");
    assertEquals(infoMessages[2], "# running a(foo)");
    assertEquals(infoMessages[3], "# running b()");
    assertEquals(infoMessages[4], "# running c()");
    assertEquals(infoMessages[5]?.startsWith("## success - duration "), true);
    assertTrue(writer.errorMessages.empty);
}
