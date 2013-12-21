import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { all, never, runTestsCommand, loader }

test void shouldCreateTestCommand() {
    assertEquals{
        expected = "test mymodule/1.0.0";
        actual = runTestsCommand {
            currentWorkingDirectory = null;
            modules = ["mymodule/1.0.0"];
            tests = [];
            noDefaultRepositories = false;
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            compileOnRun = null;
            systemProperties = [];
            verboseModes = [];
            arguments = [];
        };
    };
}

test void shouldCreateTestCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "test --verbose mymodule/1.0.0";
        actual = runTestsCommand {
            currentWorkingDirectory = null;
            modules = ["mymodule/1.0.0"];
            tests = [];
            noDefaultRepositories = false;
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            compileOnRun = null;
            systemProperties = [];
            verboseModes = all;
            arguments = [];
        };
    };
}

test void shouldCreateTestCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "test --cwd=. --no-default-repositories --offline --rep=dependencies1" +
                " --rep=dependencies2 --sysrep=system-repository --cacherep=cache-rep" +
                " --compile=never" +
                " --test='package com.acme.foo.bar','class com.acme.foo.bar::Baz','function com.acme.foo.bar::baz'" +
                " --define=ENV_VAR1=42 --define=ENV_VAR2=foo" +
                " --verbose=all,loader mymodule/1.0.0 --foo bar=toto";
        actual = runTestsCommand {
            currentWorkingDirectory = ".";
            modules = ["mymodule/1.0.0"];
            tests = ["package com.acme.foo.bar", "class com.acme.foo.bar::Baz", "function com.acme.foo.bar::baz"];
            noDefaultRepositories = true;
            offline = true;
            repositories = ["dependencies1", "dependencies2"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            compileOnRun = never;
            systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            verboseModes = [all, loader];
            arguments = ["--foo", "bar=toto"];
        };
    };
}
