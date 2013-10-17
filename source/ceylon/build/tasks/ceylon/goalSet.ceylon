import ceylon.build.task { Goal, GoalSet, keepCurrentName }

"Returns a `GoalSet` providing compile, tests-compile, test and doc tasks for a ceylon module."
shared GoalSet ceylonModule(
    "module name"
    String moduleName,
    "test module name"
    String testModuleName = "test.``moduleName``",
    "test module version"
    String testModuleVersion = "1.0.0",
    """rename function that will be applied to each goal name.
       
       Current goals names are `"compile"`, `"tests-compile"`, `"test"` and `"doc"`"""
    String(String) rename = keepCurrentName()) {
    return GoalSet {
        Goal {
            name = rename("compile");
            compile {
                compilationUnits = moduleName;
            };
        },
        Goal {
            name = rename("tests-compile");
            compile {
                compilationUnits = testModuleName;
                sourceDirectories = testSourceDirectory;
            };
        },
        Goal {
            name = rename("test");
            runModule {
                moduleName = testModuleName;
                version = testModuleVersion;
            };
        },
        Goal {
            name = rename("doc");
            document {
                modules = moduleName;
            };
        }
    };
}