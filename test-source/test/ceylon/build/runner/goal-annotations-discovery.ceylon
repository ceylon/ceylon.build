import ceylon.language.meta.declaration { Module, FunctionDeclaration }
import ceylon.test { test, assertEquals, assertThatException }
import ceylon.build.runner { findPackageMembersAnnotatedWithGoals, goalAnnotation }
import ceylon.build.task { goal, GoalAnnotation }

test void shouldNotFindGoalAnnotatedFunctionsIfNoPackage() {
    Module mod = mockModule();
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsInEmptyPackages() {
    Module mod = mockModule {
        mockPackage(),
        mockPackage()
    };
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsIfNoFunctionsAnnotatedWithIt() {
    Module mod = mockModule {
        mockPackage {
            mockFunctionDeclaration("name", shared(), doc("no doc")),
            mockFunctionDeclaration("name")
        },
        mockPackage {
            mockFunctionDeclaration("name", by("no one"))
        }
    };
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, []);
}

test void shouldFindGoalAnnotatedFunctions() {
    value goal1 = mockFunctionDeclaration("name", goal(), doc("this is a goal"));
    value goal2 = mockFunctionDeclaration("name", goal("hello"));
    value goal3 = mockFunctionDeclaration("name", goal("bye"));
    Module mod = mockModule {
        mockPackage {
            mockFunctionDeclaration("name", shared(), doc("no doc")),
            goal1,
            goal2
        },
        mockPackage {
            mockFunctionDeclaration("name", by("no one")),
            goal3
        }
    };
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, [goal1, goal2, goal3]);
}

test void shouldNotFindGoalAnnotationWhenNoAnnotations() {
    FunctionDeclaration declaration = mockFunctionDeclaration();
    assertThatException(() => goalAnnotation(declaration)).hasType(`AssertionException`);
}

test void shouldNotFindGoalAnnotationWhenNoGoalAnnotation() {
    FunctionDeclaration declaration = mockFunctionDeclaration("name", shared(), by("no one"));
    assertThatException(() => goalAnnotation(declaration)).hasType(`AssertionException`);
}

test void shouldNotFindGoalAnnotationWhenMultipleGoalAnnotation() {
    FunctionDeclaration declaration = mockFunctionDeclaration("name", goal(), goal());
    assertThatException(() => goalAnnotation(declaration)).hasType(`AssertionException`);
}

test void shouldFindGoalAnnotation() {
    GoalAnnotation annotation = goal();
    FunctionDeclaration declaration = mockFunctionDeclaration("name", annotation);
    assertEquals(goalAnnotation(declaration), annotation);
}
