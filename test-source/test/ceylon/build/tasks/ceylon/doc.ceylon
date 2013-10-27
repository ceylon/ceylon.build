import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { buildDocCommand }

test void shouldCreateDocCommand() {
    assertEquals{
        expected = "ceylon doc mymodule";
        actual = buildDocCommand {
            ceylon = "ceylon";
            modules = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            outputRepository = null;
            repositories = [];
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

test void shouldCreateDocCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon doc --encoding=UTF-8 --src=source-a --src=source-b" +
                " --out=~/.ceylon/repo --rep=dependencies1 --rep=dependencies2 --sysrep=system-repository" +
                " --user=ceylon-user --pass=ceylon-user-password --offline" +
                " --link=http://doc.mymodule.org --non-shared --source-code" +
                " --src=foo --src=bar mymodule1 mymodule2";
        actual = buildDocCommand {
            ceylon = "./ceylon";
            modules = ["mymodule1", "mymodule2"];
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            outputRepository = "~/.ceylon/repo";
            repositories = ["dependencies1", "dependencies2"];
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
