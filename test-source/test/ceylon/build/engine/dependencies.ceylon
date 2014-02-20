import ceylon.test { test }
import ceylon.build.engine { Goal, success, GoalDefinitionsBuilder, runEngine, dependencyCycleFound, undefinedGoalsFound }

test void shouldNotFoundCycleWhenNoDependencies() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value goals = [a, b, c];
    value goalsToRun = ["a", "b", "c"];
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder(goals);
            arguments = goalsToRun;
            writer = writer;
        };
        status = success;
        available = sort(names(goals));
        toRun = goalsToRun;
        successful = goalsToRun;
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages =  [
            ceylonBuildStartMessage,
            "# running goals: [a, b, c] in order",
            "# running a()",
            "# running b()",
            "# running c()"];
        errorMessages = [];
    };
}

test void shouldNotFoundCycleWhenNoCycle() {
    value writer = MockWriter();
    value a = createTestGoal("a");
    value b = createTestGoal("b");
    value c = createTestGoal("c");
    value d = createTestGoal("d", ["c"]);
    value e = createTestGoal("e", ["b", "c"]);
    value f = createTestGoal("f", ["d"]);
    value goals = [a, b, c, d, e, f];
    value goalsToRun = ["c", "d", "f", "b", "e", "a"];
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder(goals);
            arguments = ["f", "e", "d", "c", "b", "a"];
            writer = writer;
        };
        status = success;
        available = sort(names(goals));
        toRun = goalsToRun;
        successful = goalsToRun;
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages =  [
            ceylonBuildStartMessage,
            "# running goals: [c, d, f, b, e, a] in order",
            "# running c()",
            "# running d()",
            "# running f()",
            "# running b()",
            "# running e()",
            "# running a()"];
        errorMessages = [];
    };
}

test void shouldFoundUndefinedGoalDefinition() {
    value writer = MockWriter();
    value b = createTestGoal("b", ["a"]);
    checkExecutionResult {
        result = runEngine {
            goals = GoalDefinitionsBuilder([b]);
            arguments = ["b"];
            writer = writer;
        };
        status = undefinedGoalsFound;
        available = [];
        toRun = [];
        successful = [];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages =  [ceylonBuildStartMessage];
        errorMessages = ["# undefined goal referenced from dependency: [a]"];
    };
}
