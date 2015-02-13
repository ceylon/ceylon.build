import ceylon.test {
    test
}
import ceylon.build.runner {
    testAccessLoadModule
}

test void shouldLoadRunnerModule() {
    value moduleName = `module ceylon.build.runner`.name;
    value moduleVersion = `module ceylon.build.runner`.version;
    testAccessLoadModule("``moduleName``/``moduleVersion``");
}
