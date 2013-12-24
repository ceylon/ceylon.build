import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { RunJsArguments, runJsCommand, check, all, loader }

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

test void shouldCreateRunJsCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["run-js", "--verbose", "mymodule/1.0.0"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                version = "1.0.0";
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateRunJsCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["run-js", "--cwd=.", "--offline", "--rep=dependencies1", "--rep=dependencies2",
            "--sysrep=system-repository", "--cacherep=cache-rep", "--run=main", "--compile=check",
            "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "--debug=debug", "--verbose=all,loader",
            "--node-exe=/usr/bin/nodejs", "--foo", "bar=toto", "mymodule/0.1", "--", "arg1", "arg2=value"];
        actual = runJsCommand {
            RunJsArguments {
                moduleName = "mymodule";
                version = "0.1";
                moduleArguments = ["arg1", "arg2=value"];
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
                arguments = ["--foo", "bar=toto"];
            };
        };
    };
}
