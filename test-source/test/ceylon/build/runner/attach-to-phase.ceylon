import ceylon.build.runner {
    phasesDependencies
}
import ceylon.build.task {
    goal,
    attachTo
}
import ceylon.collection {
    HashMap
}
import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}
import ceylon.test {
    test,
    assertEquals
}

goal
shared void attachToGoal1() {}

goal
attachTo(`function attachToGoal1`)
shared void attachToGoal2() {}

goal
attachTo(`function attachToGoal1`)
shared void attachToGoal3() {}

goal
attachTo(`function attachToGoal2`)
shared void attachToGoal4() {}

test void shouldReadNoAttachToAnnotations() {
    assertEquals {
        actual = phasesDependencies {
            `function attachToGoal1`
        };
        expected = map();
    };
}

test void shouldReadAttachToAnnotations() {
    assertEquals {
        actual = phasesDependencies {
            `function attachToGoal1`,
            `function attachToGoal2`
        };
        expected = map {
            `function attachToGoal1` -> [`function attachToGoal2`]
        };
    };
}

test void shouldReadMultiplesAttachToAnnotations() {
    assertEquals {
        actual = phasesDependencies {
            `function attachToGoal1`,
            `function attachToGoal2`,
            `function attachToGoal3`,
            `function attachToGoal4`
        };
        expected = map {
            `function attachToGoal1` -> [`function attachToGoal2`, `function attachToGoal3`],
            `function attachToGoal2` -> [`function attachToGoal4`]
        };
    };
}

Map<FunctionOrValueDeclaration, [FunctionOrValueDeclaration*]> map(
    {<FunctionOrValueDeclaration -> [FunctionOrValueDeclaration*]>*} entries = [])
        => HashMap { entries = entries; };