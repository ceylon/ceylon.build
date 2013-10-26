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
            dependenciesRepository = null;
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
            dependenciesRepository = null;
            systemRepository = null;
            functionNameToRun = null;
            verboseModes = all;
            arguments = [];
        };
    };
}

test void shouldCreateRunCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon run --d --offline --rep=dependencies --sysrep=system-repository" +
                " --run=main --verbose=cmr mymodule/0.1 --foo bar=toto";
        actual = buildRunCommand {
            ceylon = "./ceylon";
            moduleName = "mymodule";
            version = "0.1";
            disableModuleRepository = true;
            offline = true;
            dependenciesRepository = "dependencies";
            systemRepository = "system-repository";
            functionNameToRun = "main";
            verboseModes = [cmr];
            arguments = ["--foo", "bar=toto"];
        };
    };
}
