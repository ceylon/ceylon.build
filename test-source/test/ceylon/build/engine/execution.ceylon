import ceylon.build.task { Goal, Task, Context, Success, Failure, done }
import ceylon.build.engine { runGoals, exitCodes }
import ceylon.test { assertEquals, assertTrue, test }
import ceylon.collection { HashMap, MutableMap }

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

test void shouldExitWithErrorWhenNoGoalToRun() {
    value writer = MockWriter();
    assertEquals(exitCodes.noGoalToRun, runGoals([], [], [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# no goal to run, available goals are: []"], writer.errorMessages);
    writer.clear();
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    assertEquals(exitCodes.noGoalToRun, runGoals([], ["-Da:foo"], [a, b], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# no goal to run, available goals are: [a, b]"], writer.errorMessages);
}

test void shouldExitOnTaskFailure() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = Goal("b", [(Context context) => Failure()]);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(exitCodes.errorOnTaskExecution, runGoals([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"], writer.infoMessages);
    assertEquals(["# goal b failure, stopping"], writer.errorMessages);
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
    assertEquals(exitCodes.errorOnTaskExecution, runGoals([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()"], writer.infoMessages);
    assertEquals(2, writer.errorMessages.size);
    assertEquals(["# goal b failure, stopping", "ex"], writer.errorMessages);
}

test void shouldRunGoals(){
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = Goal("b", [(Context context) => Success("b succeed")]);
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    assertEquals(exitCodes.success, runGoals([a, b, c], ["-Da:foo"], [a, b, c, d], writer));
    assertEquals([
        "# running goals: [a, b, c] in order",
        "# running a(foo)",
        "# running b()",
        "b succeed",
        "# running c()"], writer.infoMessages);
    assertTrue(writer.errorMessages.empty);
}
