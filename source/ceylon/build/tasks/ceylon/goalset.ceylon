import ceylon.build.task { goal, noop }

shared interface CeylonModule {
    
    "module name"
    shared formal String moduleName;
    
    goal
    shared default void doc() => package.document { modules = moduleName; };
}

shared interface CeylonTestModule satisfies CeylonModule {
    
    "test module name"
    shared default String testModuleName => "test.``moduleName``";
    
    "test module version"
    shared default String? testModuleVersion => defaultModuleVersion;
}

shared interface CeylonJvmModule satisfies CeylonTestModule {
    
    goal
    shared default void compile() => package.compile { modules = moduleName; };
    
    goal {
        name = "compile-tests";
    }
    shared default void compileTests() => package.compileTests { modules = testModuleName; };
    
    goal {
        name = "run-tests";
    }
    shared default void runTests() => package.test { modules = moduleVersion(testModuleName, testModuleVersion); };
    
    goal {
        dependencies = [`function compile`, `function compileTests`, `function runTests`];
    }
    shared default void test() {}
}

shared interface CeylonJsModule satisfies CeylonTestModule {
    
    goal {
        name = "compile-js";
    }
    shared default void compileJs() => package.compileJs { modules = moduleName; };
    
    goal {
        name = "compile-js-tests";
    }
    shared default void compileJsTests() => package.compileJsTests { modules = moduleName; };
    
    goal {
        name = "run-js-tests";
    }
    shared default void runJsTests() => package.runJsModule {
        moduleName = testModuleName;
        version = testModuleVersion;
    };
    
    goal {
        name = "test-js";
        dependencies = [`function compileJs`, `function compileJsTests`, `function runJsTests`];
    }
    shared default void testJs() {}
}

shared CeylonJvmModule ceylonJvmModule(
    String moduleName,
    String testModuleName = "test.``moduleName``",
    String? testModuleVersion = defaultModuleVersion) {
    value moduleNameAlias = moduleName;
    value testModuleNameAlias = testModuleName;
    value testModuleVersionAlias = testModuleVersion;
    object o satisfies CeylonJvmModule {
        
        "module name"
        shared actual String moduleName = moduleNameAlias;
        "test module name"
        shared actual String testModuleName = testModuleNameAlias;
        "test module version"
        shared actual String? testModuleVersion = testModuleVersionAlias;
        
        test = noop;
    }
    return o;
}

shared CeylonJsModule ceylonJsModule(
    String moduleName,
    String testModuleName = "test.``moduleName``",
    String? testModuleVersion = defaultModuleVersion) {
    value moduleNameAlias = moduleName;
    value testModuleNameAlias = testModuleName;
    value testModuleVersionAlias = testModuleVersion;
    object o satisfies CeylonJsModule {
        
        "module name"
        shared actual String moduleName = moduleNameAlias;
        "test module name"
        shared actual String testModuleName = testModuleNameAlias;
        "test module version"
        shared actual String? testModuleVersion = testModuleVersionAlias;
        
        testJs = noop;
    }
    return o;
}

shared CeylonJvmModule & CeylonJsModule ceylonJvmAndJsModule(
    String moduleName,
    String testModuleName = "test.``moduleName``",
    String? testModuleVersion = defaultModuleVersion) {
    value moduleNameAlias = moduleName;
    value testModuleNameAlias = testModuleName;
    value testModuleVersionAlias = testModuleVersion;
    object o satisfies CeylonJvmModule & CeylonJsModule {
        
        "module name"
        shared actual String moduleName = moduleNameAlias;
        "test module name"
        shared actual String testModuleName = testModuleNameAlias;
        "test module version"
        shared actual String? testModuleVersion = testModuleVersionAlias;
        
        test = noop;
        testJs = noop;
    }
    return o;
}
