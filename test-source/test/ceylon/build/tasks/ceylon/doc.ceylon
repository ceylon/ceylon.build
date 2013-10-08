import ceylon.test { assertEquals }
import ceylon.build.tasks.ceylon { buildDocCommand }

void shouldCreateDocCommand() {
    assertEquals{
        expected = "ceylon doc mymodule";
        actual = buildDocCommand {
            ceylon = "ceylon";
            modules = ["mymodule"];
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
}

void shouldCreateDocCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon doc --encoding=UTF-8 --src=source-a --src=source-b" +
                " --out=~/.ceylon/repo --rep=dependencies --sysrep=system-repository" +
                " --user=ceylon-user --pass=ceylon-user-password --offline" +
                " --link=http://doc.mymodule.org --non-shared --source-code" +
                " --src=foo --src=bar mymodule1 mymodule2";
        actual = buildDocCommand {
            ceylon = "./ceylon";
            modules = ["mymodule1", "mymodule2"];
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
