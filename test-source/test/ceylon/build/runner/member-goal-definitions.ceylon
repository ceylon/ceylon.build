import ceylon.test { test, assertEquals }
import ceylon.build.task { goal, noop, NoOp }
import ceylon.build.runner { goalDefinition, goalDeclarationsFromIncludes }
import ceylon.collection { HashSet }

class Container() {
    
    shared goal void goalMethod() {
        accumulator.add(`function goalMethod`.name);
    }
    
    shared goal("goal-with-name-specified-method") void goalWithNameSpecifiedMethod() {
        accumulator.add(`function goalWithNameSpecifiedMethod`.name);
    }
    
    // FIXME not possible because of "metamodel reference to local declaration" error
    // TODO when it will be possible, need to be able to access it and to add a test for it
    //goal void internalGoalMethod() {
    //    accumulator.add(`function internalGoalMethod`.name);
    //}

    shared goal Integer goalMethodWithReturnType() {
        accumulator.add(`function goalMethodWithReturnType`.name);
        return 0;
    }
    
    shared goal void invalidGoalMethod(Object parameter) {
        accumulator.add(`function invalidGoalMethod`.name);
    }
    
    shared goal Anything invalidGoalAttribute = noop;
    
    shared goal NoOp noopGoalAttribute = noop;
}

test void shouldBuildGoalDefinitionFromMethod() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`function Container.goalMethod`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("goalMethod");
        expectedAccumulatorContent = ["goalMethod"];
    };
}

// TODO add tests with inheritance (goal name specified in supertype, and another test were refined in subtype)
test void shouldBuildGoalDefinitionFromMethodWithNameSpecified() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`function Container.goalWithNameSpecifiedMethod`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("goal-with-name-specified-method");
        expectedAccumulatorContent = ["goalWithNameSpecifiedMethod"];
    };
}

test void shouldBuildGoalDefinitionFromMethodWithReturnType() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`function Container.goalMethodWithReturnType`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition {
            name = "goalMethodWithReturnType";
        };
        expectedAccumulatorContent = ["goalMethodWithReturnType"];
    };
}

test void shouldBuildGoalDefinitionFromNoOpAttribute() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`value Container.noopGoalAttribute`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition {
            name = "noopGoalAttribute";
            task = false;
        };
        expectedAccumulatorContent = [];
    };
}

test void shouldFailToBuildInvalidGoalDefinitionMethod() {
    value container = Container();
    checkInvalidGoalDefinition(goalDefinition(`function Container.invalidGoalMethod`, emptyPhases, container));
}

test void shouldFailToBuildInvalidGoalDefinitionAttribute() {
    value container = Container();
    checkInvalidGoalDefinition(goalDefinition(`value Container.invalidGoalAttribute`, emptyPhases, container));
}

Container containerValue = Container();

test void shouldFindIncludedGoals() {
    value definitions = goalDeclarationsFromIncludes([`value containerValue`]);
    assertEquals {
        actual = HashSet { elements = definitions; };
        expected = HashSet {
            `function Container.goalMethod` -> containerValue,
            `function Container.goalWithNameSpecifiedMethod` -> containerValue,
            `function Container.goalMethodWithReturnType` -> containerValue,
            `function Container.invalidGoalMethod` -> containerValue,
            `value Container.invalidGoalAttribute` -> containerValue,
            `value Container.noopGoalAttribute` -> containerValue
        };
    };
}
