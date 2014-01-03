import ceylon.language.meta.declaration { Module }
import ceylon.test { test, assertEquals }
import ceylon.build.runner { findAnnotatedGoals, findAnnotatedIncludes }
import ceylon.build.task { include }

test void shouldNotFindIncludeAnnotatedValuesIfNoPackage() {
    Module mod = mockModule();
    value results = findAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindIncludeAnnotatedValuesInEmptyPackages() {
    Module mod = mockModule {
        mockPackage(),
        mockPackage()
    };
    value results = findAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindIncludeAnnotatedValuesIfNoValuesAnnotatedWithIt() {
    Module mod = mockModule {
        mockPackage {
            mockValueDeclaration(shared(), doc("no doc")),
            mockValueDeclaration()
        },
        mockPackage {
            mockValueDeclaration(by("no one"))
        }
    };
    value results = findAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldFindIncludeAnnotatedValues() {
    value include1 = mockValueDeclaration(include(), doc("this is a include"));
    value include2 = mockValueDeclaration(include());
    value include3 = mockValueDeclaration(include());
    Module mod = mockModule {
        mockPackage {
            mockValueDeclaration(shared(), doc("no doc")),
            include1,
            include2
        },
        mockPackage {
            mockValueDeclaration(by("no one")),
            include3
        }
    };
    value results = findAnnotatedIncludes(mod);
    assertEquals(results, [include1, include2, include3]);
}
