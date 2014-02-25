import ceylon.test { test, assertEquals }
import ceylon.build.task { goal, noop, NoOp }
import ceylon.build.runner { goalDefinition, goalsDefinition, InvalidGoalDeclaration }
import ceylon.build.engine { Goal }
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
        actual = HashSet { for (definition in definitions) convert(definition) };
        expected = HashSet {
            ExpectedDefinition("goal-with-name-specified-method"),
            ExpectedDefinition("goalMethodWithReturnType"),
            InvalidGoalDeclaration(`function Container.invalidGoalMethod`),
            ExpectedDefinition("goalMethod")
        };
    };
}

// TODO add tests with inheritance (goal name specified in supertype / interfaces,
// TODO and another test were refined in subtype)
ExpectedDefinition|InvalidGoalDeclaration convert(Goal|InvalidGoalDeclaration definition) {
    switch (definition)
    case (is Goal) {
        value properties = definition.properties;
        return ExpectedDefinition {
            name = definition.name;
            task = properties.task exists;
            internal = properties.internal;
            dependencies = properties.dependencies;
        };
    } case (is InvalidGoalDeclaration)  {
        return definition;
    }
}

