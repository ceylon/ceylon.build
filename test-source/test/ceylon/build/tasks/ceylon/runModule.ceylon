import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { all, buildRunCommand, cmr }

test void shouldCreateRunCommand() {
    assertEquals{
        expected = "ceylon run mymodule/1.0.0";
        actual = buildRunCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            version = "1.0.0";
            disableModuleRepository = false;
            offline = false;
            repositories = [];
            systemRepository = null;
            functionNameToRun = null;
            verboseModes = [];
            arguments = [];
        };
    };
}

test void shouldCreateRunCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "ceylon run --verbose mymodule/1.0.0";
        actual = buildRunCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            version = "1.0.0";
            disableModuleRepository = false;
            offline = false;
            repositories = [];
            systemRepository = null;
            functionNameToRun = null;
            verboseModes = all;
            arguments = [];
        };
    };
}

test void shouldCreateRunCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon run --d --offline --rep=dependencies1 --rep=dependencies2 --sysrep=system-repository" +
                " --run=main --verbose=cmr mymodule/0.1 --foo bar=toto";
        actual = buildRunCommand {
            ceylon = "./ceylon";
            moduleName = "mymodule";
            version = "0.1";
            disableModuleRepository = true;
            offline = true;
            repositories = ["dependencies1", "dependencies2"];
            systemRepository = "system-repository";
            functionNameToRun = "main";
            verboseModes = [cmr];
            arguments = ["--foo", "bar=toto"];
        };
    };
}
