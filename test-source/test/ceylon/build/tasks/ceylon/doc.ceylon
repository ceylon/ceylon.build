import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { docCommand, all, loader }

test void shouldCreateDocCommand() {
    assertEquals{
        expected = "doc mymodule";
        actual = docCommand {
            currentWorkingDirectory = null;
            modules = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            documentationDirectory = null;
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            link = null;
            includeNonShared = false;
            includeSourceCode = false;
            ignoreBrokenLink = false;
            ignoreMissingDoc = false;
            ignoreMissingThrows = false;
            header = null;
            footer = null;
            systemProperties = [];
            verboseModes = [];
            arguments = [];
        };
    };
}

test void shouldCreateDocCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "doc --verbose mymodule";
        actual = docCommand {
            currentWorkingDirectory = null;
            modules = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            documentationDirectory = null;
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            link = null;
            includeNonShared = false;
            includeSourceCode = false;
            ignoreBrokenLink = false;
            ignoreMissingDoc = false;
            ignoreMissingThrows = false;
            header = null;
            footer = null;
            systemProperties = [];
            verboseModes = all;
            arguments = [];
        };
    };
}


test void shouldCreateDocCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "doc --cwd=. --encoding=UTF-8 --source=source-a --source=source-b --doc=./doc-folder" +
                " --out=~/.ceylon/repo --rep=dependencies1 --rep=dependencies2 --sysrep=system-repository" +
                " --cacherep=cache-rep --user=ceylon-user --pass=ceylon-user-password --offline" +
                " --link=http://doc.mymodule.org --non-shared --source-code" +
                " --ignore-broken-link --ignore-missing-doc --ignore-missing-throws" +
                " --header=custom header --footer=custom footer"+
                " --define=ENV_VAR1=42 --define=ENV_VAR2=foo --verbose=all,loader" +
                " --source=foo --source=bar mymodule1 mymodule2";
        actual = docCommand {
            currentWorkingDirectory = ".";
            modules = ["mymodule1", "mymodule2"];
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            documentationDirectory = "./doc-folder";
            outputRepository = "~/.ceylon/repo";
            repositories = ["dependencies1", "dependencies2"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            link = "http://doc.mymodule.org";
            includeNonShared = true;
            includeSourceCode = true;
            ignoreBrokenLink = true;
            ignoreMissingDoc = true;
            ignoreMissingThrows = true;
            header = "custom header";
            footer = "custom footer";
            systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            verboseModes = [all, loader];
            arguments = ["--source=foo", "--source=bar"];
        };
    };
}
