import ceylon.test { assertEquals }
import ceylon.build.tasks.ceylon { buildCompileCommand, all, loader, cmrloader, benchmark, code, ast }

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
}

void shouldCreateCompileCommandWithAllVerboseFlag() {
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
}

void shouldCreateCompileCommandWithAllParametersSpecified() {
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
