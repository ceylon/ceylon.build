import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { all, runCommand, cmr, never }

test void shouldCreateRunCommand() {
    assertEquals{
        expected = "run mymodule/1.0.0";
        actual = runCommand {
            currentWorkingDirectory = null;
            moduleName = "mymodule";
            version = "1.0.0";
            moduleArguments = [];
            noDefaultRepositories = false;
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            functionNameToRun = null;
            compileOnRun = null;
            systemProperties = [];
            verboseModes = [];
            arguments = [];
        };
    };
}

test void shouldCreateRunCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "run --verbose mymodule/1.0.0";
        actual = runCommand {
            currentWorkingDirectory = null;
            moduleName = "mymodule";
            version = "1.0.0";
            moduleArguments = [];
            noDefaultRepositories = false;
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            functionNameToRun = null;
            compileOnRun = null;
            systemProperties = [];
            verboseModes = all;
            arguments = [];
        };
    };
}

test void shouldCreateRunCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "run --cwd=. --no-default-repositories --offline --rep=dependencies1" +
                " --rep=dependencies2 --sysrep=system-repository --cacherep=cache-rep" +
                " --run=main --compile=never --define=ENV_VAR1=42 --define=ENV_VAR2=foo" +
                " --verbose=cmr --foo bar=toto mymodule/0.1 -- arg1 arg2=value";
        actual = runCommand {
            currentWorkingDirectory = ".";
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
            verboseModes = [cmr];
            arguments = ["--foo", "bar=toto"];
        };
    };
}
