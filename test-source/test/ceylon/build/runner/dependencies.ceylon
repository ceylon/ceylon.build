import ceylon.build.engine {
    Goal
}
import ceylon.build.runner {
    goalDefinition,
    InvalidGoalDeclaration
}
import ceylon.build.task {
    goal,
    dependsOn,
    attachTo
}
import ceylon.collection {
    HashMap
}
import ceylon.test {
    test,
    assertEquals
}
import test.ceylon.build.runner { emptyPhases }

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
dependsOn(`function standAloneNamedGoal`)
shared void goalWithMultiplesDependency() {}

goal
dependsOn(`function standAloneGoal`, `function standAloneNamedGoal`)
shared void goalWithMultiplesDependencyInOneAnnotation() {}

test void shouldHaveOneDependency() {
    shouldHaveDependencies(goalDefinition(`function goalWithOneDependency`, emptyPhases), ["standAloneGoal"]);
    shouldHaveDependencies(goalDefinition(`function standAloneGoal`, emptyPhases), []);
}

test void shouldHaveOneNamedDependency() {
    shouldHaveDependencies(goalDefinition(`function goalWithOneNamedDependency`, emptyPhases), ["named-goal"]);
    shouldHaveDependencies(goalDefinition(`function standAloneNamedGoal`, emptyPhases), []);
}

test void shouldHaveMultiplesDependenciesFromMultipleAnnotations() {
    shouldHaveDependencies(goalDefinition(`function goalWithMultiplesDependency`, emptyPhases),
        ["standAloneGoal", "named-goal"]);
    shouldHaveDependencies(goalDefinition(`function standAloneGoal`, emptyPhases), []);
    shouldHaveDependencies(goalDefinition(`function standAloneNamedGoal`, emptyPhases), []);
}

test void shouldHaveMultiplesDependenciesFromOneAnnotation() {
    shouldHaveDependencies(goalDefinition(`function goalWithMultiplesDependencyInOneAnnotation`, emptyPhases),
        ["standAloneGoal", "named-goal"]);
    shouldHaveDependencies(goalDefinition(`function standAloneGoal`, emptyPhases), []);
    shouldHaveDependencies(goalDefinition(`function standAloneNamedGoal`, emptyPhases), []);
}

goal
attachTo(`function standAloneNamedGoal2`)
shared void standAloneGoal2() {}

goal("named-goal2")
shared void standAloneNamedGoal2() {}

goal
attachTo(`function goalWithOneDependency2`)
shared void standAloneNamedGoal3() {}

goal
dependsOn(`function standAloneNamedGoal2`)
shared void goalWithOneDependency2() {}


test void shouldAttachGoalToPhase() {
    value phases = HashMap { entries = {
            `function standAloneGoal2` -> [`function standAloneNamedGoal2`]
        };
    };
    shouldHaveDependencies(goalDefinition(`function standAloneGoal2`, phases), ["named-goal2"]);
    shouldHaveDependencies(goalDefinition(`function standAloneNamedGoal2`, phases), []);
}

test void shouldConcatenateDependenciesAndAttachTo() {
    value phases = HashMap { entries = {
            `function goalWithOneDependency2` -> [`function standAloneNamedGoal3`]
        };
    };
    shouldHaveDependencies(goalDefinition(`function goalWithOneDependency2`, phases),
        ["named-goal2", "standAloneNamedGoal3"]);
    shouldHaveDependencies(goalDefinition(`function standAloneNamedGoal2`, phases), []);
    shouldHaveDependencies(goalDefinition(`function standAloneNamedGoal3`, phases), []);
}

void shouldHaveDependencies(Goal|InvalidGoalDeclaration goal, [String*] dependencies) {
    assert(is Goal goal);
    assertEquals(goal.properties.dependencies, dependencies);
}
