import ceylon.test { test, assertEquals }
import ceylon.build.task { goal, noop, NoOp }
import ceylon.build.runner { goalDefinition, goalsDefinition, InvalidGoalDeclaration }
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
        goal = goalDefinition(`function Container.goalMethod`, container);
        expectedDefinition = ExpectedDefinition("goalMethod");
        expectedAccumulatorContent = ["goalMethod"];
    };
}

// TODO add tests with inheritance (goal name specified in supertype, and another test were refined in subtype)
test void shouldBuildGoalDefinitionFromMethodWithNameSpecified() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`function Container.goalWithNameSpecifiedMethod`, container);
        expectedDefinition = ExpectedDefinition("goal-with-name-specified-method");
        expectedAccumulatorContent = ["goalWithNameSpecifiedMethod"];
    };
}

test void shouldBuildGoalDefinitionFromMethodWithReturnType() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`function Container.goalMethodWithReturnType`, container);
        expectedDefinition = ExpectedDefinition {
            name = "goalMethodWithReturnType";
        };
        expectedAccumulatorContent = ["goalMethodWithReturnType"];
    };
}

test void shouldBuildGoalDefinitionFromNoOpAttribute() {
    value container = Container();
    checkGoalDefinition {
        goal = goalDefinition(`value Container.noopGoalAttribute`, container);
        expectedDefinition = ExpectedDefinition {
            name = "noopGoalAttribute";
            task = false;
        };
        expectedAccumulatorContent = [];
    };
}

test void shouldFailToBuildInvalidGoalDefinitionMethod() {
    value container = Container();
    checkInvalidGoalDefinition(goalDefinition(`function Container.invalidGoalMethod`, container));
}

test void shouldFailToBuildInvalidGoalDefinitionAttribute() {
    value container = Container();
    checkInvalidGoalDefinition(goalDefinition(`value Container.invalidGoalAttribute`, container));
}

Container containerValue = Container();

test void shouldFindAndBuildIncludedGoals() {
    value definitions = goalsDefinition(`value containerValue`);
    assertEquals {
        actual = HashSet { elements = expectedDefinitionList(definitions); };
        expected = HashSet {
            ExpectedDefinition("goalMethod"),
            ExpectedDefinition("goal-with-name-specified-method"),
            ExpectedDefinition("goalMethodWithReturnType"),
            InvalidGoalDeclaration(`function Container.invalidGoalMethod`),
            InvalidGoalDeclaration(`value Container.invalidGoalAttribute`),
            ExpectedDefinition("noopGoalAttribute", false)
        };
    };
}

