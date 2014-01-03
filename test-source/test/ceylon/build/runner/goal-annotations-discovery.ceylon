import ceylon.language.meta.declaration { Module }
import ceylon.test { test, assertEquals }
import ceylon.build.runner { findAnnotatedGoals }
import ceylon.build.task { goal }

test void shouldNotFindGoalAnnotatedFunctionsIfNoPackage() {
    Module mod = mockModule();
    value results = findAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsInEmptyPackages() {
    Module mod = mockModule {
        mockPackage(),
        mockPackage()
    };
    value results = findAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsIfNoFunctionsAnnotatedWithIt() {
    Module mod = mockModule {
        mockPackage {
            mockFunctionDeclaration(shared(), doc("no doc")),
            mockFunctionDeclaration()
        },
        mockPackage {
            mockFunctionDeclaration(by("no one"))
        }
    };
    value results = findAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldFindGoalAnnotatedFunctions() {
    value goal1 = mockFunctionDeclaration(goal(), doc("this is a goal"));
    value goal2 = mockFunctionDeclaration(goal("hello"));
    value goal3 = mockFunctionDeclaration(goal("bye"));
    Module mod = mockModule {
        mockPackage {
            mockFunctionDeclaration(shared(), doc("no doc")),
            goal1,
            goal2
        },
        mockPackage {
            mockFunctionDeclaration(by("no one")),
            goal3
        }
    };
    value results = findAnnotatedGoals(mod);
    assertEquals(results, [goal1, goal2, goal3]);
}

test void shouldNotFindGoalAnnotationWhenNoAnnotations() {
    FunctionDeclaration declaration = mockFunctionDeclaration();
    assertThatException(() => goalAnnotation(declaration)).hasType(`AssertionException`);
}

test void shouldNotFindGoalAnnotationWhenNoGoalAnnotation() {
    FunctionDeclaration declaration = mockFunctionDeclaration(shared(), by("no one"));
    assertThatException(() => goalAnnotation(declaration)).hasType(`AssertionException`);
}

test void shouldNotFindGoalAnnotationWhenMultipleGoalAnnotation() {
    FunctionDeclaration declaration = mockFunctionDeclaration(goal(), goal());
    assertThatException(() => goalAnnotation(declaration)).hasType(`AssertionException`);
}

test void shouldFindGoalAnnotation() {
    GoalAnnotation annotation = goal();
    FunctionDeclaration declaration = mockFunctionDeclaration(annotation);
    assertEquals(goalAnnotation(declaration), annotation);
}
