import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { compileJsCommand }

test void shouldCreateCompileJsCommand() {
    assertEquals{
        expected = "compile-js mymodule";
        actual = compileJsCommand {
            currentWorkingDirectory = null;
            modules = ["mymodule"];
            files = [];
            encoding = null;
            sourceDirectories = [];
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            compact = false;
            lexicalScopeStyle = false;
            noComments = false;
            noIndent = false;
            noModule = false;
            optimize = false;
            profile = false;
            skipSourceArchive = false;
            systemProperties = [];
            verbose = false;
            arguments = [];
        };
    };
}

test void shouldCreateCompileJsCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "compile-js --cwd=. --encoding=UTF-8 --source=source-a --source=source-b" +
                " --out=~/.ceylon/repo --rep=dependencies1 --rep=dependencies2 --sysrep=system-repository" +
                " --cacherep=cache-rep --user=ceylon-user --pass=ceylon-user-password --offline --compact" +
                " --lexical-scope-style --no-comments --no-indent --no-module --optimize --profile --skip-src-archive" +
                " --define=ENV_VAR1=42 --define=ENV_VAR2=foo --verbose --source=foo --source=bar module1 module2 file1.js file2.js";
        actual = compileJsCommand {
            currentWorkingDirectory = ".";
            modules = ["module1", "module2"];
            files = ["file1.js", "file2.js"];
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            outputRepository = "~/.ceylon/repo";
            repositories = ["dependencies1", "dependencies2"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            compact = true;
            lexicalScopeStyle = true;
            noComments = true;
            noIndent = true;
            noModule = true;
            optimize = true;
            profile = true;
            skipSourceArchive = true;
            systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            verbose = true;
            arguments = ["--source=foo", "--source=bar"];
        };
    };
}
