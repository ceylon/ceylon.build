import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { RunJsArguments, runJsCommand, all, loader, never, once, check, force }

test void shouldCreateRunJsCommand() {
    assertEquals {
        expected = ["run-js", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithVersion() {
    assertEquals {
        expected = ["run-js", "mymodule/1.0.0"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                version = "1.0.0";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithModuleArguments() {
    assertEquals {
        expected = ["run-js", "mymodule", "--", "--flag", "arg1", "arg2=value"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                moduleArguments = ["--flag", "arg1", "arg2=value"];
            };
        };
    };
}

test void shouldCreateRunJsCommandWithNoDefaultRepositories() {
    assertEquals {
        expected = ["run-js", "--no-default-repositories", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                noDefaultRepositories = true;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithOffline() {
    assertEquals {
        expected = ["run-js", "--offline", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                offline = true;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithRepositories() {
    assertEquals {
        expected = ["run-js", "--rep=dependencies1", "--rep=../dependencies2", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                repositories = ["dependencies1", "../dependencies2"];
            };
        };
    };
}

test void shouldCreateRunJsCommandWithSystemRepository() {
    assertEquals {
        expected = ["run-js", "--sysrep=../repo", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                systemRepository = "../repo";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithCacheRepository() {
    assertEquals {
        expected = ["run-js", "--cacherep=../cache", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                cacheRepository = "../cache";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithFunctionNameToRun() {
    assertEquals {
        expected = ["run-js", "--run=com.acme.bar.main", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                functionNameToRun = "com.acme.bar.main";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithCompileOnRunJsNever() {
    assertEquals {
        expected = ["run-js", "--compile=never", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                compileOnRun = never;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithCompileOnRunJsOnce() {
    assertEquals {
        expected = ["run-js", "--compile=once", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                compileOnRun = once;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithCompileOnRunJsCheck() {
    assertEquals {
        expected = ["run-js", "--compile=check", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                compileOnRun = check;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithCompileOnRunJsForce() {
    assertEquals {
        expected = ["run-js", "--compile=force", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                compileOnRun = force;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithSystemProperties() {
    assertEquals {
        expected = ["run-js", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            };
        };
    };
}

test void shouldCreateRunJsCommandWithDebug() {
    assertEquals {
        expected = ["run-js", "--debug=debug", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                debug = "debug";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["run-js", "--verbose", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithVerboseModes() {
    assertEquals {
        expected = ["run-js", "--verbose=all,loader", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                verboseModes = [all, loader];
            };
        };
    };
}

test void shouldCreateRunJsCommandWithPathToNodeJs() {
    assertEquals {
        expected = ["run-js", "--node-exe=/usr/bin/nodejs", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                pathToNodeJs = "/usr/bin/nodejs";
            };
        };
    };
}

test void shouldCreateRunJsCommandWithCurrentWorkingDirectory() {
    assertEquals {
        expected = ["run-js", "--cwd=..", "mymodule"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                currentWorkingDirectory = "..";
            };
        };
    };
}


test void shouldCreateRunJsCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["run-js", "--cwd=.", "--offline", "--no-default-repositories", "--rep=dependencies1",
            "--rep=dependencies2", "--sysrep=system-repository", "--cacherep=cache-rep", "--run=main",
            "--compile=check", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "--debug=debug",
            "--verbose=all,loader", "--node-exe=/usr/bin/nodejs", "mymodule/0.1", "--", "arg1", "arg2=value"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                version = "0.1";
                moduleArguments = ["arg1", "arg2=value"];
                noDefaultRepositories = true;
                offline = true;
                repositories = ["dependencies1", "dependencies2"];
                systemRepository = "system-repository";
                cacheRepository = "cache-rep";
                functionNameToRun = "main";
                compileOnRun = check;
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
                debug = "debug";
                verboseModes = [all, loader];
                pathToNodeJs = "/usr/bin/nodejs";
                currentWorkingDirectory = ".";
            };
        };
    };
}
