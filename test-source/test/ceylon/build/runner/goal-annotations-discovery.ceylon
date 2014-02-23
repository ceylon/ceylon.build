import ceylon.language.meta.declaration { Module }
import ceylon.test { test, assertEquals }
import ceylon.build.runner { findPackageMembersAnnotatedWithGoals }
import ceylon.build.task { goal }

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
