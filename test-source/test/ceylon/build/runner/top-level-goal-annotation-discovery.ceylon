import ceylon.language.meta.declaration { Module }
import ceylon.test { test, assertEquals }
import ceylon.build.runner { findPackageMembersAnnotatedWithGoals }
import ceylon.build.task { goal }

test void shouldNotFindGoalAnnotatedFunctionsOrValuesIfNoPackage() {
    Module mod = mockModule();
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsOrValuesInEmptyPackages() {
    Module mod = mockModule {
        mockPackage(),
        mockPackage()
    };
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsOrValuesIfNoFunctionsOrValuesAnnotatedWithIt() {
    Module mod = mockModule {
        mockPackage {
            mockFunctionDeclaration(shared(), doc("no doc")),
            mockFunctionDeclaration(),
            mockValueDeclaration(shared(), doc("no doc")),
            mockValueDeclaration()
        },
        mockPackage {
            mockFunctionDeclaration(by("no one"))
        }
    };
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, []);
}

test void shouldFindGoalAnnotatedFunctionsAndValues() {
    value goal1 = mockFunctionDeclaration(goal(), doc("this is a goal"));
    value goal2 = mockFunctionDeclaration(goal("hello"));
    value goal3 = mockFunctionDeclaration(goal("bye"));
    value goal4 = mockValueDeclaration(goal(), doc("this is a goal"));
    value goal5 = mockValueDeclaration(goal("hello"));
    value goal6 = mockValueDeclaration(goal("bye"));
    Module mod = mockModule {
        mockPackage {
            mockFunctionDeclaration(shared(), doc("no doc")),
            goal1,
            goal2,
            goal4
        },
        mockPackage {
            mockFunctionDeclaration(by("no one")),
            goal3,
            goal5,
            goal6
        }
    };
    value results = findPackageMembersAnnotatedWithGoals(mod);
    assertEquals(results, [goal1, goal2, goal4, goal3, goal5, goal6]);
}
