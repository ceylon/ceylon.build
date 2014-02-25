import ceylon.test { test, assertEquals }
import ceylon.build.task { goal }
import ceylon.build.runner { goalsDefinition }
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
    value definitions = goalsDefinition(`value subContainer2Value`);
    assertEquals {
        actual = HashSet { elements = expectedDefinitionList(definitions); };
        expected = HashSet {
            ExpectedDefinition("goalDefinedOnSuperClass"),
            ExpectedDefinition("name-specified-in-sub-class-1"),
            ExpectedDefinition("goalDefinedOnSubClass1"),
            ExpectedDefinition("refined"),
            ExpectedDefinition("goalDefinedOnSubClass2")
        };
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
    value definitions = goalsDefinition(`value containerWithInterface`);
    assertEquals {
        actual = HashSet { elements = expectedDefinitionList(definitions); };
        expected = HashSet {
            ExpectedDefinition("goalDefinedOnInterface"),
            ExpectedDefinition("name-specified-in-interface")
        };
    };
}
