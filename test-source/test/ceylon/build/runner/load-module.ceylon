import ceylon.test {
    test
}
import ceylon.build.runner {
    testAccessLoadModule
}

test void shouldLoadRunnerModule() {
    value moduleName = `module ceylon.build.runner`.name;
    value moduleVersion = `module ceylon.build.runner`.version;
    value loadedModule = testAccessLoadModule("``moduleName``/``moduleVersion``");
    "Expected module to exists"
    assert(exists loadedModule);
    assert(loadedModule.name == moduleName);
    assert(loadedModule.version == moduleVersion);
}
