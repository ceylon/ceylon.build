import ceylon.test { test }
import ceylon.build.task { goal, noop, NoOp }
import ceylon.build.runner { goalDefinition }

shared goal void goalFunction() {
    accumulator.add(`function goalFunction`.name);
}

shared goal("goal-with-name-specified-function") void goalWithNameSpecifiedFunction() {
    accumulator.add(`function goalWithNameSpecifiedFunction`.name);
}

goal void internalGoalFunction() {
    accumulator.add(`function internalGoalFunction`.name);
}

shared goal Integer goalFunctionWithReturnType() {
    accumulator.add(`function goalFunctionWithReturnType`.name);
    return 0;
}

shared goal void invalidGoalFunction(Object parameter) {
    accumulator.add(`function invalidGoalFunction`.name);
}

shared goal NoOp noopGoalValue = noop;

shared goal Anything invalidGoalValue = noop;

test void shouldBuildGoalDefinitionFromFunction() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalFunction`, emptyPhases);
        expectedDefinition = ExpectedDefinition("goalFunction");
        expectedAccumulatorContent = ["goalFunction"];
    };
}

test void shouldBuildGoalDefinitionFromFunctionWithReturnType() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalFunctionWithReturnType`, emptyPhases);
        expectedDefinition = ExpectedDefinition("goalFunctionWithReturnType");
        expectedAccumulatorContent = ["goalFunctionWithReturnType"];
    };
}

test void shouldBuildGoalDefinitionFromFunctionWithNameSpecified() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalWithNameSpecifiedFunction`, emptyPhases);
        expectedDefinition = ExpectedDefinition("goal-with-name-specified-function");
        expectedAccumulatorContent = ["goalWithNameSpecifiedFunction"];
    };
}

test void shouldBuildGoalDefinitionFromInternalFunction() {
    checkGoalDefinition {
        goal = goalDefinition(`function internalGoalFunction`, emptyPhases);
        expectedDefinition = ExpectedDefinition {
            name = "internalGoalFunction";
            internal = true;
        };
        expectedAccumulatorContent = ["internalGoalFunction"];
    };
}

test void shouldBuildGoalDefinitionFromNoOpValue() {
    checkGoalDefinition {
        goal = goalDefinition(`value noopGoalValue`, emptyPhases);
        expectedDefinition = ExpectedDefinition {
            name = "noopGoalValue";
            task = false;
        };
        expectedAccumulatorContent = [];
    };
}

test void shouldFailToBuildInvalidGoalDefinitionFunction() {
    checkInvalidGoalDefinition(goalDefinition(`function invalidGoalFunction`, emptyPhases));
}

test void shouldFailToBuildInvalidGoalDefinitionValue() {
    checkInvalidGoalDefinition(goalDefinition(`value invalidGoalValue`, emptyPhases));
}
