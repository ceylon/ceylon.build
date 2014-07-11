import ceylon.test { test, assertEquals }
import ceylon.build.task { goal }
import ceylon.build.runner { goalDeclarationsFromIncludes, goalDefinition }
import ceylon.collection { HashSet }

class SuperContainer() {
    
    shared goal void goalDefinedOnSuperClass() {
        accumulator.add(`function goalDefinedOnSuperClass`.name);
    }
    
    shared default goal void goalRefinedInSubClass1() {
        accumulator.add(`function goalRefinedInSubClass1`.name);
    }
}

class SubContainer1() extends SuperContainer() {
    
    shared goal("name-specified-in-sub-class-1") void goalDefinedOnSubClass1WithNameSpecified() {
        accumulator.add(`function goalDefinedOnSubClass1WithNameSpecified`.name);
    }
    
    shared goal void goalDefinedOnSubClass1() {
        accumulator.add(`function goalDefinedOnSubClass1`.name);
    }
    
    shared actual goal("refined") void goalRefinedInSubClass1() {
        accumulator.add(`function goalRefinedInSubClass1`.name);
    }
}

class SubContainer2() extends SubContainer1() {
    
    shared goal void goalDefinedOnSubClass2() {
        accumulator.add(`function goalDefinedOnSubClass2`.name);
    }
}

SubContainer1 subContainer1Value = SubContainer1();
SubContainer2 subContainer2Value = SubContainer2();

test void shouldFindSuperClassesGoals() {
    value definitions = goalDeclarationsFromIncludes([`value subContainer2Value`]);
    assertEquals {
        actual = HashSet { elements = definitions; };
        expected = HashSet {
            `function SuperContainer.goalDefinedOnSuperClass` -> subContainer2Value,
            `function SubContainer1.goalDefinedOnSubClass1WithNameSpecified` -> subContainer2Value,
            `function SubContainer1.goalDefinedOnSubClass1` -> subContainer2Value,
            `function SubContainer1.goalRefinedInSubClass1` -> subContainer2Value,
            `function SubContainer2.goalDefinedOnSubClass2` -> subContainer2Value
        };
    };
}

test void shouldBuildGoalDefinitionFromMethodOnSupertype() {
    value container = SubContainer2();
    checkGoalDefinition {
        goal = goalDefinition(`function SuperContainer.goalDefinedOnSuperClass`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("goalDefinedOnSuperClass");
        expectedAccumulatorContent = ["goalDefinedOnSuperClass"];
    };
}

test void shouldBuildGoalDefinitionFromMethodWithNameSpecifiedInSupertype() {
    value container = SubContainer2();
    checkGoalDefinition {
        goal = goalDefinition(`function SubContainer1.goalDefinedOnSubClass1WithNameSpecified`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("name-specified-in-sub-class-1");
        expectedAccumulatorContent = ["goalDefinedOnSubClass1WithNameSpecified"];
    };
}

test void shouldBuildGoalDefinitionFromMethodOnDirectSupertype() {
    value container = SubContainer2();
    checkGoalDefinition {
        goal = goalDefinition(`function SubContainer1.goalDefinedOnSubClass1`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("goalDefinedOnSubClass1");
        expectedAccumulatorContent = ["goalDefinedOnSubClass1"];
    };
}

test void shouldBuildGoalDefinitionFromMethodRefined() {
    value container = SubContainer2();
    checkGoalDefinition {
        goal = goalDefinition(`function SubContainer1.goalRefinedInSubClass1`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("refined");
        expectedAccumulatorContent = ["goalRefinedInSubClass1"];
    };
}

test void shouldBuildGoalDefinitionFromMethodOnBottomType() {
    value container = SubContainer2();
    checkGoalDefinition {
        goal = goalDefinition(`function SubContainer2.goalDefinedOnSubClass2`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("goalDefinedOnSubClass2");
        expectedAccumulatorContent = ["goalDefinedOnSubClass2"];
    };
}

interface InterfaceWithGoal {
    shared goal("name-specified-in-interface") void goalDefinedOnInterfaceWithNameSpecified() {
        accumulator.add(`function goalDefinedOnInterfaceWithNameSpecified`.name);
    }
    
    shared goal void goalDefinedOnInterface() {
        accumulator.add(`function goalDefinedOnInterface`.name);
    }
}

class ContainerWithInterface() satisfies InterfaceWithGoal {}

ContainerWithInterface containerWithInterface = ContainerWithInterface();

test void shouldFindGoalsDefinedOnInterfaces() {
    value definitions = goalDeclarationsFromIncludes([`value containerWithInterface`]);
    assertEquals {
        actual = HashSet { elements = definitions; };
        expected = HashSet {
            `function InterfaceWithGoal.goalDefinedOnInterface` -> containerWithInterface,
            `function InterfaceWithGoal.goalDefinedOnInterfaceWithNameSpecified` -> containerWithInterface
        };
    };
}

test void shouldBuildGoalDefinitionFromMethodOnInterface() {
    value container = ContainerWithInterface();
    checkGoalDefinition {
        goal = goalDefinition(`function InterfaceWithGoal.goalDefinedOnInterface`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("goalDefinedOnInterface");
        expectedAccumulatorContent = ["goalDefinedOnInterface"];
    };
}

test void shouldBuildGoalDefinitionFromMethodWithNameSpecifiedInInterface() {
    value container = ContainerWithInterface();
    checkGoalDefinition {
        goal = goalDefinition(`function InterfaceWithGoal.goalDefinedOnInterfaceWithNameSpecified`, emptyPhases, container);
        expectedDefinition = ExpectedDefinition("name-specified-in-interface");
        expectedAccumulatorContent = ["goalDefinedOnInterfaceWithNameSpecified"];
    };
}

