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
        rename = rename;
        Goal {
            name = "compile";
            compile {
                moduleName = moduleName;
            };
        },
        Goal {
            name = "tests-compile";
            compile {
                moduleName = testModuleName;
                sourceDirectories = testSourceDirectory;
            };
        },
        Goal {
            name = "test";
            runModule {
                moduleName = testModuleName;
                version = testModuleVersion;
            };
        },
        Goal {
            name = "doc";
            document {
                moduleName = moduleName;
            };
        }
    };
}