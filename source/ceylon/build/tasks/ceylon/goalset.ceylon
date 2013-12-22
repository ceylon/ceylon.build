import ceylon.build.task { Goal, GoalSet, keepCurrentName }

"Compilation / Execution targets"
shared class Target(jvm, javascript) {
    
    "`true` if target is JVM backend"
    shared Boolean jvm;
    
    "`true` if target is Javascript backend"
    shared Boolean javascript;
}

"""Returns a `GoalSet` providing goals to compile, test and document ceylon modules.
   
   Following goals will be returned:
   - `"doc"`: document module
   
   JVM specific goals:
   - `"compile"`: compile module
   - `"compile-tests"`: compile test module
   - `"run-tests"`: run test module
   - `"test"`: compile module, compile test module and run test module
   
   Javascript specific goals:
   - `"compile-js"`: compile module
   - `"compile-js-tests"`: compile test module
   - `"run-js-tests"`: run test module
   - `"test-js"`: compile module, compile test module and run test module
   """
shared GoalSet ceylonModule(
    "module name"
    String moduleName,
    "test module name"
    String testModuleName = "test.``moduleName``",
    "test module version"
    String? testModuleVersion = defaultModuleVersion,
    "Targeted backend (JVM and/or Javascript)"
    Target target = Target { jvm = true; javascript = true; },
    """rename function that will be applied to each goal name"""
    String(String) rename = keepCurrentName()) {
    [Goal*] jvmTargetGoals;
    if (target.jvm) {
        jvmTargetGoals = jvmGoals(rename, moduleName, testModuleName, testModuleVersion);
    } else {
        jvmTargetGoals = [];
    }
    [Goal*] javascriptTargetGoals;
    if (target.javascript) {
        javascriptTargetGoals = javascriptGoals(rename, moduleName, testModuleName, testModuleVersion);
    } else {
        javascriptTargetGoals = [];
    }
    value docGoal = Goal {
        name = rename("doc");
        document {
            modules = moduleName;
        }
    };
    value goals = concatenate(jvmTargetGoals, javascriptTargetGoals, [docGoal]);
    assert(nonempty goals);
    return GoalSet(goals);
}

[Goal+] jvmGoals(String(String) rename, String moduleName, String testModuleName, String? testModuleVersion) {
    value compileGoal = Goal {
        name = rename("compile");
        compile {
            modules = moduleName;
        }
    };
    value compileTestsGoal = Goal {
        name = rename("compile-tests");
        compileTests {
            modules = testModuleName;
        }
    };
    value runTestsGoal = Goal {
        name = rename("run-tests");
        runTests {
            modules = moduleVersion(testModuleName, testModuleVersion);
        }
    };
    value testGoal = Goal {
        name = rename("test");
        dependencies = [compileGoal, compileTestsGoal, runTestsGoal];
    };
    return [compileGoal, compileTestsGoal, runTestsGoal, testGoal];
}

[Goal+] javascriptGoals(String(String) rename, String moduleName, String testModuleName, String? testModuleVersion) {
    value compileJsGoal = Goal {
        name = rename("compile-js");
        compileJs {
            modules = moduleName;
        }
    };
    value compileJsTestsGoal = Goal {
        name = rename("compile-js-tests");
        compileJsTests {
            modules = testModuleName;
        }
    };
    value runJsTestsGoal = Goal {
        name = rename("run-js-tests");
        runJsModule {
            moduleName = testModuleName;
            version = testModuleVersion;
        }
    };
    value testJsGoal = Goal {
        name = rename("test-js");
        dependencies = [compileJsGoal, compileJsTestsGoal, runJsTestsGoal];
    };
    return [compileJsGoal, compileJsTestsGoal, runJsTestsGoal, testJsGoal];
}
