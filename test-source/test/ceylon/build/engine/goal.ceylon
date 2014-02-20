import ceylon.test { test }
import ceylon.build.engine { Goal, duplicateGoalsFound, invalidGoalFound, GoalDefinitionsBuilder, runEngine, success }

test void shouldNotFindDuplicateGoals() {
    checkDuplicateGoals {
        goals = [createTestGoal("a"), createTestGoal("b"), createTestGoal("c")];
        duplicates = [];
    };
}

test void shouldFindOneDuplicateGoals() {
    checkDuplicateGoals {
        goals = [createTestGoal("a"), createTestGoal("b"), createTestGoal("c"), createTestGoal("b")];
        duplicates = ["b"];
    };
}

test void shouldFindMultiplesDuplicateGoals() {
    checkDuplicateGoals {
        goals = [createTestGoal("a"), createTestGoal("b"), createTestGoal("b"), createTestGoal("a")];
        duplicates = ["a", "b"];
    };
}

void checkDuplicateGoals([Goal+] goals, [String*] duplicates) {
    value writer = MockWriter();
    value goalsToRun = names(goals);
    if (nonempty duplicates) {
        checkExecutionResult {
            result = runEngine {
                goals = GoalDefinitionsBuilder(goals);
                arguments = goalsToRun;
                writer = writer;
            };
            status = duplicateGoalsFound;
            available = [];
            toRun = [];
            successful = [];
            failed = [];
            notRun = [];
            writer = writer;
            infoMessages = [ceylonBuildStartMessage];
            errorMessages = ["# duplicate goal names found: ``duplicates``"];
        };
    } else {
        checkSuccess(goals, goalsToRun, writer);
    }
}

test void testValidateGoalName() {
    checkGoalName("", false);
    checkGoalName("0", false);
    checkGoalName("00", false);
    checkGoalName("0a0", false);
    checkGoalName("0aa", false);
    checkGoalName("-", false);
    checkGoalName("-a", false);
    checkGoalName("_", false);
    checkGoalName("_A", false);
    checkGoalName("A", false);
    checkGoalName("a", true);
    checkGoalName("a", true);
    checkGoalName("a_", false);
    checkGoalName("ab", true);
    checkGoalName("a-b", true);
    checkGoalName("a0b", true);
    checkGoalName("a0b1", true);
    checkGoalName("compile-mod1", true);
    checkGoalName("compile-mod1", true);
    checkGoalName("compile_mod1", false);
    checkGoalName("compile mod1", false);
}

test void testValidateGoalsName() {
    value compile = createTestGoal("compile");
    value test = createTestGoal("test");
    value compileAndRun = createTestGoal("compile run");
    value compileAndTest = createTestGoal("compile_test");
    checkInvalidGoalsNames([compile], []);
    checkInvalidGoalsNames([compile, test], []);
    checkInvalidGoalsNames([compileAndRun, test], ["compile run"]);
    checkInvalidGoalsNames([compileAndRun, compileAndTest], ["compile run", "compile_test"]);
}

void checkGoalName(String name, Boolean valid) {
    checkInvalidGoalsNames([createTestGoal(name)], valid then [] else [name]);
}

void checkSuccess([Goal+] goals, String[] goalsToRun, MockWriter writer) => checkExecutionResult {
            result = runEngine {
                goals = GoalDefinitionsBuilder(goals);
                arguments = goalsToRun;
                writer = writer;
            };
            status = success;
            available = sort(goalsToRun);
            toRun = goalsToRun;
            successful = goalsToRun;
            failed = [];
            notRun = [];
            writer = writer;
            infoMessages = concatenate(
                [ceylonBuildStartMessage, "# running goals: ``goalsToRun`` in order"],
                [ for (goal in goalsToRun) "# running ``goal``()"]
            ).sequence;
            errorMessages = [];
        };

void checkInvalidGoalsNames([Goal+] goals, [String*] invalidGoals) {
    value goalsToRun = names(goals);
    value writer = MockWriter();
    if (nonempty invalidGoals) {
        checkExecutionResult {
            result = runEngine {
                goals = GoalDefinitionsBuilder(goals);
                arguments = goalsToRun;
                writer = writer;
            };
            status = invalidGoalFound;
            available = [];
            toRun = [];
            successful = [];
            failed = [];
            notRun = [];
            writer = writer;
            infoMessages = [ceylonBuildStartMessage];
            errorMessages = [
                "# invalid goals found ``invalidGoals``",
                "# goal name should match following format: `[a-z][a-zA-Z0-9-.]*`"
            ];
        };
    } else {
        checkSuccess(goals, goalsToRun, writer);
    }
}
