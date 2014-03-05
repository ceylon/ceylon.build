import ceylon.build.task { goal, noop, NoOp }

shared interface CeylonModule {
    
    "module name"
    shared formal String moduleName;
    
    "test module name"
    shared default String testModuleName => testModuleNameFromModuleName(moduleName);
    
    "test module version"
    shared default String? testModuleVersion => defaultModuleVersion;
    
    goal
    shared default void doc() => package.document { modules = moduleName; };
}

shared class CeylonBaseModule(
    moduleName,
    testModuleName = testModuleNameFromModuleName(moduleName),
    testModuleVersion = defaultModuleVersion)
    satisfies CeylonModule {
    
    "module name"
    shared actual String moduleName;
    "test module name"
    shared actual String testModuleName;
    "test module version"
    shared actual String? testModuleVersion;
}

shared interface CeylonJvmModule satisfies CeylonModule {
    
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
    shared default NoOp test => noop;
}

shared interface CeylonJsModule satisfies CeylonModule {
    
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
    shared default NoOp testJs => noop;
}

shared CeylonJvmModule ceylonJvmModule(
    String moduleName,
    String testModuleName = testModuleNameFromModuleName(moduleName),
    String? testModuleVersion = defaultModuleVersion) {
    value moduleNameAlias = moduleName;
    value testModuleNameAlias = testModuleName;
    value testModuleVersionAlias = testModuleVersion;
    object o extends CeylonBaseModule(moduleNameAlias, testModuleNameAlias, testModuleVersionAlias)
            satisfies CeylonJvmModule {
        test = noop;
    }
    return o;
}

shared CeylonJsModule ceylonJsModule(
    String moduleName,
    String testModuleName = testModuleNameFromModuleName(moduleName),
    String? testModuleVersion = defaultModuleVersion) {
    value moduleNameAlias = moduleName;
    value testModuleNameAlias = testModuleName;
    value testModuleVersionAlias = testModuleVersion;
    object o extends CeylonBaseModule(moduleNameAlias, testModuleNameAlias, testModuleVersionAlias)
            satisfies CeylonJsModule {
        testJs = noop;
    }
    return o;
}

shared CeylonJvmModule & CeylonJsModule ceylonJvmAndJsModule(
    String moduleName,
    String testModuleName = testModuleNameFromModuleName(moduleName),
    String? testModuleVersion = defaultModuleVersion) {
    value moduleNameAlias = moduleName;
    value testModuleNameAlias = testModuleName;
    value testModuleVersionAlias = testModuleVersion;
    object o extends CeylonBaseModule(moduleNameAlias, testModuleNameAlias, testModuleVersionAlias)
            satisfies CeylonJvmModule & CeylonJsModule {
        test = noop;
        testJs = noop;
    }
    return o;
}

String testModuleNameFromModuleName(String moduleName) => "test.``moduleName``";
