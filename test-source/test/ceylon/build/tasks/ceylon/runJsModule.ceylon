import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { runJsCommand }

test void shouldCreateRunJsCommand() {
    assertEquals{
        expected = "ceylon run-js mymodule/1.0.0";
        actual = runJsCommand {
            ceylon = "ceylon";
            currentWorkingDirectory = null;
            moduleName = "mymodule";
            version = "1.0.0";
            offline = false;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            functionNameToRun = null;
            debug = null;
            pathToNodeJs = null;
            arguments = [];
        };
    };
}

test void shouldCreateRunJsCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon run-js --cwd=. --offline --rep=dependencies1 --rep=dependencies2" +
                " --sysrep=system-repository --cacherep=cache-rep" +
                " --run=main --debug=debug --node-exe=/usr/bin/nodejs mymodule/0.1 --foo bar=toto";
        actual = runJsCommand {
            ceylon = "./ceylon";
            currentWorkingDirectory = ".";
            moduleName = "mymodule";
            version = "0.1";
            offline = true;
            repositories = ["dependencies1", "dependencies2"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            functionNameToRun = "main";
            debug = "debug";
            pathToNodeJs = "/usr/bin/nodejs";
            arguments = ["--foo", "bar=toto"];
        };
    };
}
