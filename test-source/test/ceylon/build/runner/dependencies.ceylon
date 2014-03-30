import ceylon.build.runner {
    goalDefinition
}
import ceylon.build.task {
    goal,
    dependsOn
}
import ceylon.test {
    test
}

goal
shared void standAloneGoal() {}

goal("named-goal")
shared void standAloneNamedGoal() {}

goal
dependsOn(`function standAloneGoal`)
shared void goalWithOneDependency() {}

goal
dependsOn(`function standAloneNamedGoal`)
shared void goalWithOneNamedDependency() {}

goal
dependsOn(`function standAloneGoal`)
dependsOn(`function goalWithOneDependency`)
shared void goalWithMultiplesDependency() {}

goal
dependsOn(`function standAloneGoal`, `function goalWithOneDependency`)
shared void goalWithMultiplesDependencyInOneAnnotation() {}

test void shouldBuildGoalWithOneDependency() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalWithOneDependency`, emptyPhases);
        expectedDefinition = ExpectedDefinition {
            name = "goalWithOneDependency";
            dependencies = ["standAloneGoal"];
        };
    };
}

test void shouldBuildGoalWithOneNamedDependency() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalWithOneNamedDependency`, emptyPhases);
        expectedDefinition = ExpectedDefinition {
            name = "goalWithOneNamedDependency";
            dependencies = ["named-goal"];
        };
    };
}

test void shouldBuildGoalWithMultiplesDependencies() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalWithMultiplesDependency`, emptyPhases);
        expectedDefinition = ExpectedDefinition {
            name = "goalWithMultiplesDependency";
            dependencies = ["standAloneGoal", "goalWithOneDependency"];
        };
    };
}

test void shouldBuildGoalWithMultiplesDependenciesInOneAnnotation() {
    checkGoalDefinition {
        goal = goalDefinition(`function goalWithMultiplesDependencyInOneAnnotation`, emptyPhases);
        expectedDefinition = ExpectedDefinition {
            name = "goalWithMultiplesDependencyInOneAnnotation";
            dependencies = ["standAloneGoal", "goalWithOneDependency"];
        };
    };
}
