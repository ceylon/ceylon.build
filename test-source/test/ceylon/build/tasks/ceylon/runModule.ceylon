import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { RunArguments, runCommand, all, cmr, loader, never, once, check, force }

test void shouldCreateRunCommand() {
    assertEquals {
        expected = ["run", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
            };
        };
    };
}

test void shouldCreateRunCommandWithVersion() {
    assertEquals {
        expected = ["run", "mymodule/1.0.0"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                version = "1.0.0";
            };
        };
    };
}

test void shouldCreateRunCommandWithModuleArguments() {
    assertEquals {
        expected = ["run", "mymodule", "--", "--flag", "arg1", "arg2=value"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                moduleArguments = ["--flag", "arg1", "arg2=value"];
            };
        };
    };
}

test void shouldCreateRunCommandWithNoDefaultRepositories() {
    assertEquals {
        expected = ["run", "--no-default-repositories", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                noDefaultRepositories = true;
            };
        };
    };
}

test void shouldCreateRunCommandWithOffline() {
    assertEquals {
        expected = ["run", "--offline", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                offline = true;
            };
        };
    };
}

test void shouldCreateRunCommandWithRepositories() {
    assertEquals {
        expected = ["run", "--rep=dependencies1", "--rep=../dependencies2", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                repositories = ["dependencies1", "../dependencies2"];
            };
        };
    };
}

test void shouldCreateRunCommandWithSystemRepository() {
    assertEquals {
        expected = ["run", "--sysrep=../repo", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                systemRepository = "../repo";
            };
        };
    };
}

test void shouldCreateRunCommandWithCacheRepository() {
    assertEquals {
        expected = ["run", "--cacherep=../cache", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                cacheRepository = "../cache";
            };
        };
    };
}

test void shouldCreateRunCommandWithFunctionNameToRun() {
    assertEquals {
        expected = ["run", "--run=com.acme.bar.main", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                functionNameToRun = "com.acme.bar.main";
            };
        };
    };
}

test void shouldCreateRunCommandWithCompileOnRunNever() {
    assertEquals {
        expected = ["run", "--compile=never", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                compileOnRun = never;
            };
        };
    };
}

test void shouldCreateRunCommandWithCompileOnRunOnce() {
    assertEquals {
        expected = ["run", "--compile=once", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                compileOnRun = once;
            };
        };
    };
}

test void shouldCreateRunCommandWithCompileOnRunCheck() {
    assertEquals {
        expected = ["run", "--compile=check", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                compileOnRun = check;
            };
        };
    };
}

test void shouldCreateRunCommandWithCompileOnRunForce() {
    assertEquals {
        expected = ["run", "--compile=force", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                compileOnRun = force;
            };
        };
    };
}

test void shouldCreateRunCommandWithSystemProperties() {
    assertEquals {
        expected = ["run", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            };
        };
    };
}

test void shouldCreateRunCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["run", "--verbose", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateRunCommandWithVerboseModes() {
    assertEquals {
        expected = ["run", "--verbose=all,loader,cmr", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                verboseModes = [all, loader, cmr];
            };
        };
    };
}

test void shouldCreateRunCommandWithCurrentWorkingDirectory() {
    assertEquals {
        expected = ["run", "--cwd=..", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateRunCommandWithArguments() {
    assertEquals {
        expected = ["run", "--foo", "bar=toto", "mymodule"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                arguments = ["--foo", "bar=toto"];
            };
        };
    };
}

test void shouldCreateRunCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["run", "--cwd=.", "--no-default-repositories", "--offline", "--rep=dependencies1",
            "--rep=dependencies2", "--sysrep=system-repository", "--cacherep=cache-rep", "--run=main",
            "--compile=never", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "--verbose=all,loader,cmr",
            "--foo", "bar=toto", "mymodule/0.1", "--", "arg1", "arg2=value"];
        actual = runCommand {
            RunArguments {
                moduleName = "mymodule";
                version = "0.1";
                moduleArguments = ["arg1", "arg2=value"];
                noDefaultRepositories = true;
                offline = true;
                repositories = ["dependencies1", "dependencies2"];
                systemRepository = "system-repository";
                cacheRepository = "cache-rep";
                functionNameToRun = "main";
                compileOnRun = never;
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
                verboseModes = [all, loader, cmr];
                currentWorkingDirectory = ".";
                arguments = ["--foo", "bar=toto"];
            };
        };
    };
}
