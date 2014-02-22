import ceylon.build.task { context }
import ceylon.build.engine { GoalDefinitionsBuilder, runEngine, success }
import ceylon.test { assertEquals, test }
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
    value writer = MockWriter();
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder(goals);
            arguments = [goalNameA, *inputArguments];
            writer = writer;
        };
        status = success;
        available = [goalNameA];
        toRun = [goalNameA];
        successful = [goalNameA];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [
            ceylonBuildStartMessage,
            "# running goals: [``goalNameA``] in order",
            "# running a(``", ".join(expectedGoalArguments)``)"];
        errorMessages = [];
    };
    assertEquals(argumentsMap.get(goalNameA) else [], expectedGoalArguments);
}

test void shouldRunGoals() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value d = createTestGoal("d");
    value goals = [a, b, c, d];
    value toRun = ["a", "b", "c"];
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder(goals);
            arguments = ["a", "b", "c", "-Da:foo"];
            writer = writer;
        };
        status = success;
        available = sort(names(goals));
        toRun = toRun;
        successful = toRun;
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [
            ceylonBuildStartMessage,
            "# running goals: ``toRun`` in order",
            "# running a(foo)",
            "# running b()",
            "# running c()"];
        errorMessages = [];
    };
}
