import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { runJsCommand, check, all, loader, defaultModuleVersion }

test void shouldCreateRunJsCommand() {
    assertEquals {
        expected = ["run-js", "mymodule"];
        actual = runJsCommand {
            currentWorkingDirectory = null;
            moduleName = "mymodule";
            version = defaultModuleVersion;
            moduleArguments = [];
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            functionNameToRun = null;
            compileOnRun = null;
            systemProperties = [];
            debug = null;
            verboseModes = [];
            pathToNodeJs = null;
            arguments = [];
        };
    };
}

test void shouldCreateRunJsCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["run-js", "--verbose", "mymodule/1.0.0"];
        actual = runJsCommand {
            currentWorkingDirectory = null;
            moduleName = "mymodule";
            version = "1.0.0";
            moduleArguments = [];
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            functionNameToRun = null;
            compileOnRun = null;
            systemProperties = [];
            debug = null;
            verboseModes = all;
            pathToNodeJs = null;
            arguments = [];
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
            currentWorkingDirectory = ".";
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
            arguments = ["--foo", "bar=toto"];
        };
    };
}
