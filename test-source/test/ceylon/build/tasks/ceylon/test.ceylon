import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { TestArguments, testCommand, moduleVersion, all, loader, never, once, check, force }

test void shouldCreateTestCommand() {
    assertEquals {
        expected = ["test", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
            };
        };
    };
}

test void shouldCreateTestCommandWithVersion() {
    assertEquals {
        expected = ["test", "mymodule/1.0.0"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule", "1.0.0")];
            };
        };
    };
}

test void shouldCreateTestCommandWithMultiplesModules() {
    assertEquals {
        expected = ["test", "mymodule1", "mymodule2/1.5.3", "mymodule3/3.0.1"];
        actual = testCommand {
            TestArguments {
                modules = [
                    moduleVersion("mymodule1"),
                    moduleVersion("mymodule2", "1.5.3"),
                    moduleVersion("mymodule3", "3.0.1")
                ];
            };
        };
    };
}

test void shouldCreateTestCommandWithTests() {
    assertEquals {
        expected = [
            "test",
            "--test='package com.acme.foo.bar'",
            "--test='class com.acme.foo.bar::Baz'",
            "--test='function com.acme.foo.bar::baz'",
            "mymodule"
        ];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                tests = ["package com.acme.foo.bar", "class com.acme.foo.bar::Baz", "function com.acme.foo.bar::baz"];
            };
        };
    };
}

test void shouldCreateTestCommandWithNoDefaultRepositories() {
    assertEquals {
        expected = ["test", "--no-default-repositories", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                noDefaultRepositories = true;
            };
        };
    };
}

test void shouldCreateTestCommandWithOffline() {
    assertEquals {
        expected = ["test", "--offline", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                offline = true;
            };
        };
    };
}

test void shouldCreateTestCommandWithRepositories() {
    assertEquals {
        expected = ["test", "--rep=dependencies1", "--rep=../dependencies2", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                repositories = ["dependencies1", "../dependencies2"];
            };
        };
    };
}

test void shouldCreateTestCommandWithSystemRepository() {
    assertEquals {
        expected = ["test", "--sysrep=../repo", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                systemRepository = "../repo";
            };
        };
    };
}

test void shouldCreateTestCommandWithCacheRepository() {
    assertEquals {
        expected = ["test", "--cacherep=../cache", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                cacheRepository = "../cache";
            };
        };
    };
}

test void shouldCreateTestCommandWithCompileOnRunNever() {
    assertEquals {
        expected = ["test", "--compile=never", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                compileOnRun = never;
            };
        };
    };
}

test void shouldCreateTestCommandWithCompileOnRunOnce() {
    assertEquals {
        expected = ["test", "--compile=once", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                compileOnRun = once;
            };
        };
    };
}

test void shouldCreateTestCommandWithCompileOnRunCheck() {
    assertEquals {
        expected = ["test", "--compile=check", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                compileOnRun = check;
            };
        };
    };
}

test void shouldCreateTestCommandWithCompileOnRunForce() {
    assertEquals {
        expected = ["test", "--compile=force", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                compileOnRun = force;
            };
        };
    };
}

test void shouldCreateTestCommandWithSystemProperties() {
    assertEquals {
        expected = ["test", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            };
        };
    };
}

test void shouldCreateTestCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["test", "--verbose", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateTestCommandWithVerboseModes() {
    assertEquals {
        expected = ["test", "--verbose=all,loader", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                verboseModes = [all, loader];
            };
        };
    };
}

test void shouldCreateTestCommandWithCurrentWorkingDirectory() {
    assertEquals {
        expected = ["test", "--cwd=..", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateTestCommandWithArguments() {
    assertEquals {
        expected = ["test", "--foo", "bar=toto", "mymodule"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule")];
                arguments = ["--foo", "bar=toto"];
            };
        };
    };
}

test void shouldCreateTestCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["test", "--cwd=.", "--no-default-repositories", "--offline", "--rep=dependencies1",
            "--rep=dependencies2", "--sysrep=system-repository", "--cacherep=cache-rep", "--compile=never",
            "--test='package com.acme.foo.bar'", "--test='class com.acme.foo.bar::Baz'",
            "--test='function com.acme.foo.bar::baz'", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo",
            "--verbose=all,loader", "--foo", "bar=toto", "mymodule/1.0.0"];
        actual = testCommand {
            TestArguments {
                modules = [moduleVersion("mymodule", "1.0.0")];
                tests = ["package com.acme.foo.bar", "class com.acme.foo.bar::Baz", "function com.acme.foo.bar::baz"];
                noDefaultRepositories = true;
                offline = true;
                repositories = ["dependencies1", "dependencies2"];
                systemRepository = "system-repository";
                cacheRepository = "cache-rep";
                compileOnRun = never;
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
                verboseModes = [all, loader];
                currentWorkingDirectory = ".";
                arguments = ["--foo", "bar=toto"];
             };
        };
    };
}
