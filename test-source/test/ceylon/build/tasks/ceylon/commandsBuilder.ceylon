import ceylon.test { assertEquals }
import ceylon.build.tasks.ceylon { buildCompileCommand, all, loader, cmrloader, benchmark, code, ast, buildCompileJsCommand, buildDocCommand, buildRunCommand, buildRunJsCommand, cmr }

shared void testCommandsBuilder() {
    shouldCreateCompileCommand();
    shouldCreateCompileJsCommand();
    shouldCreateDocCommand();
    shouldCreateRunCommand();
    shouldCreateRunJsCommand();
}

void shouldCreateCompileCommand() {
    assertEquals{
        expected = "ceylon compile mymodule";
        actual = buildCompileCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            encoding = null;
            sourceDirectories = [];
            javacOptions = null;
            outputModuleRepository = null;
            dependenciesRepository = null;
            systemRepository = null;
            user = null;
            password = null;
            offline = false;
            disableModuleRepository = false;
            verboseModes = [];
            arguments = [];
        };
    };
    assertEquals{
        expected = "ceylon compile --verbose mymodule";
        actual = buildCompileCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            encoding = null;
            sourceDirectories = [];
            javacOptions = null;
            outputModuleRepository = null;
            dependenciesRepository = null;
            systemRepository = null;
            user = null;
            password = null;
            offline = false;
            disableModuleRepository = false;
            verboseModes = all;
            arguments = [];
        };
    };
    assertEquals{
        expected = "./ceylon compile --encoding=UTF-8 --src=source-a --src=source-b" +
                " --javac=-g:source,lines,vars --out=~/.ceylon/repo --rep=dependencies" +
                " --sysrep=system-repository --user=ceylon-user --pass=ceylon-user-password" +
                " --offline --d --verbose=loader,ast,code,cmrloader,benchmark" +
                " --src=foo --src=bar mymodule";
        actual = buildCompileCommand {
            ceylon = "./ceylon";
            moduleName = "mymodule";
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            javacOptions = "-g:source,lines,vars";
            outputModuleRepository = "~/.ceylon/repo";
            dependenciesRepository = "dependencies";
            systemRepository = "system-repository";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            disableModuleRepository = true;
            verboseModes = [loader, ast, code, cmrloader, benchmark];
            arguments = ["--src=foo", "--src=bar"];
        };
    };
}


void shouldCreateCompileJsCommand() {
    assertEquals{
        expected = "ceylon compile-js mymodule";
        actual = buildCompileJsCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            encoding = null;
            sourceDirectories = [];
            outputModuleRepository = null;
            dependenciesRepository = null;
            systemRepository = null;
            user = null;
            password = null;
            offline = false;
            compact = false;
            noComments = false;
            noIndent = false;
            noModule = false;
            optimize = false;
            profile = false;
            skipSourceArchive = false;
            verbose = false;
            arguments = [];
        };
    };
    assertEquals{
        expected = "./ceylon compile-js --encoding=UTF-8 --src=source-a --src=source-b" +
                " --out=~/.ceylon/repo --rep=dependencies --sysrep=system-repository" +
                " --user=ceylon-user --pass=ceylon-user-password --offline --compact" +
                " --no-comments --no-indent --no-module --optimize --profile" +
                " --skip-src-archive --verbose --src=foo --src=bar mymodule";
        actual = buildCompileJsCommand {
            ceylon = "./ceylon";
            moduleName = "mymodule";
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            outputModuleRepository = "~/.ceylon/repo";
            dependenciesRepository = "dependencies";
            systemRepository = "system-repository";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            compact = true;
            noComments = true;
            noIndent = true;
            noModule = true;
            optimize = true;
            profile = true;
            skipSourceArchive = true;
            verbose = true;
            arguments = ["--src=foo", "--src=bar"];
        };
    };
}


void shouldCreateDocCommand() {
    assertEquals{
        expected = "ceylon doc mymodule";
        actual = buildDocCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            encoding = null;
            sourceDirectories = [];
            outputModuleRepository = null;
            dependenciesRepository = null;
            systemRepository = null;
            user = null;
            password = null;
            offline = false;
            link = null;
            includeNonShared = false;
            includeSourceCode = false;
            arguments = [];
        };
    };
    assertEquals{
        expected = "./ceylon doc --encoding=UTF-8 --src=source-a --src=source-b" +
                " --out=~/.ceylon/repo --rep=dependencies --sysrep=system-repository" +
                " --user=ceylon-user --pass=ceylon-user-password --offline" +
                " --link=http://doc.mymodule.org --non-shared --source-code" +
                " --src=foo --src=bar mymodule";
        actual = buildDocCommand {
            ceylon = "./ceylon";
            moduleName = "mymodule";
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            outputModuleRepository = "~/.ceylon/repo";
            dependenciesRepository = "dependencies";
            systemRepository = "system-repository";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            link = "http://doc.mymodule.org";
            includeNonShared = true;
            includeSourceCode = true;
            arguments = ["--src=foo", "--src=bar"];
        };
    };
}


void shouldCreateRunCommand() {
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

void shouldCreateRunJsCommand() {
    assertEquals{
        expected = "ceylon run-js mymodule/1.0.0";
        actual = buildRunJsCommand {
            ceylon = "ceylon";
            moduleName = "mymodule";
            version = "1.0.0";
            offline = false;
            dependenciesRepository = null;
            systemRepository = null;
            functionNameToRun = null;
            debug = null;
            pathToNodeJs = null;
            arguments = [];
        };
    };
    assertEquals{
        expected = "./ceylon run-js --offline --rep=dependencies --sysrep=system-repository" +
                " --run=main --debug=debug --node-exe=/usr/bin/nodejs mymodule/0.1 --foo bar=toto";
        actual = buildRunJsCommand {
            ceylon = "./ceylon";
            moduleName = "mymodule";
            version = "0.1";
            offline = true;
            dependenciesRepository = "dependencies";
            systemRepository = "system-repository";
            functionNameToRun = "main";
            debug = "debug";
            pathToNodeJs = "/usr/bin/nodejs";
            arguments = ["--foo", "bar=toto"];
        };
    };
}