import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { DocArguments, docCommand, all, loader }

test void shouldCreateDocCommand() {
    assertEquals {
        expected = ["doc", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
            };
        };
    };
}

test void shouldCreatedocCommandWithEncoding() {
    assertEquals {
        expected = ["doc", "--encoding=UTF-8", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                encoding = "UTF-8";
            };
        };
    };
}
test void shouldCreatedocCommandWithSourceDirectories() {
    assertEquals {
        expected = ["doc", "--source=src-x", "--source=src-y", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                sourceDirectories = ["src-x", "src-y"];
            };
        };
    };
}

test void shouldCreatedocCommandWithDocumentationDirectory() {
    assertEquals {
        expected = ["doc", "--doc=../doc", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                documentationDirectory = "../doc";
            };
        };
    };
}

test void shouldCreatedocCommandWithOutputRepository() {
    assertEquals {
        expected = ["doc", "--out=../modules", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                outputRepository = "../modules";
            };
        };
    };
}

test void shouldCreatedocCommandWithRepositories() {
    assertEquals {
        expected = ["doc", "--rep=../modules", "--rep=../../modules", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                repositories = ["../modules", "../../modules"];
            };
        };
    };
}

test void shouldCreatedocCommandWithSystemRepository() {
    assertEquals {
        expected = ["doc", "--sysrep=~/.ceylon/repo", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                systemRepository = "~/.ceylon/repo";
            };
        };
    };
}

test void shouldCreatedocCommandWithCacheRepository() {
    assertEquals {
        expected = ["doc", "--cacherep=~/.ceylon/cache", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                cacheRepository = "~/.ceylon/cache";
            };
        };
    };
}

test void shouldCreatedocCommandWithUser() {
    assertEquals {
        expected = ["doc", "--user=john.doe", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                user = "john.doe";
            };
        };
    };
}

test void shouldCreatedocCommandWithPassword() {
    assertEquals {
        expected = ["doc", "--pass=Pa$$w0rd", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                password = "Pa$$w0rd";
            };
        };
    };
}

test void shouldCreatedocCommandWithOffline() {
    assertEquals {
        expected = ["doc", "--offline", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                offline = true;
            };
        };
    };
}

test void shouldCreatedocCommandWithLink() {
    assertEquals {
        expected = ["doc", "--link=https://modules.ceylon-lang.org", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                link = "https://modules.ceylon-lang.org";
            };
        };
    };
}

test void shouldCreatedocCommandWithIncludeNonShared() {
    assertEquals {
        expected = ["doc", "--non-shared", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                includeNonShared = true;
            };
        };
    };
}

test void shouldCreatedocCommandWithIncludeSourceCode() {
    assertEquals {
        expected = ["doc", "--source-code", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                includeSourceCode = true;
            };
        };
    };
}

test void shouldCreatedocCommandWithIgnoreBrokenLink() {
    assertEquals {
        expected = ["doc", "--ignore-broken-link", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                ignoreBrokenLink = true;
            };
        };
    };
}

test void shouldCreatedocCommandWithIgnoreMissingDoc() {
    assertEquals {
        expected = ["doc", "--ignore-missing-doc", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                ignoreMissingDoc = true;
            };
        };
    };
}

test void shouldCreatedocCommandWithIgnoreMissingThrows() {
    assertEquals {
        expected = ["doc", "--ignore-missing-throws", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                ignoreMissingThrows = true;
            };
        };
    };
}

test void shouldCreatedocCommandWithHeader() {
    assertEquals {
        expected = ["doc", "--header=custom header", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                header = "custom header";
            };
        };
    };
}

test void shouldCreatedocCommandWithFooter() {
    assertEquals {
        expected = ["doc", "--footer=custom footer", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                footer = "custom footer";
            };
        };
    };
}

test void shouldCreatedocCommandWithSystemProperties() {
    assertEquals {
        expected = ["doc", "--define=KEY1=value1", "--define=KEY2=value2", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                systemProperties = ["KEY1" -> "value1", "KEY2" -> "value2"];
            };
        };
    };
}

test void shouldCreatedocCommandWithVerboseModes() {
    assertEquals {
        expected = ["doc", "--verbose=all,loader", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                verboseModes = [all, loader];
            };
        };
    };
}

test void shouldCreatedocCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["doc", "--verbose", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                verboseModes = all;
            };
        };
    };
}

test void shouldCreatedocCommandWithCurrentWorkingDirectory() {
    assertEquals {
        expected = ["doc", "--cwd=..", "mymodule"];
        actual = docCommand {
            DocArguments {
                modules = ["mymodule"];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateDocCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["doc", "--cwd=.", "--encoding=UTF-8", "--source=source-a", "--source=source-b",
        "--doc=./doc-folder", "--out=~/.ceylon/repo", "--rep=dependencies1", "--rep=dependencies2",
        "--sysrep=system-repository", "--cacherep=cache-rep", "--user=ceylon-user",
        "--pass=ceylon-user-password", "--offline", "--link=http://doc.mymodule.org", "--non-shared",
        "--source-code", "--ignore-broken-link", "--ignore-missing-doc", "--ignore-missing-throws",
        "--header=custom header", "--footer=custom footer", "--define=ENV_VAR1=42",
        "--define=ENV_VAR2=foo", "--verbose=all,loader", "mymodule1", "mymodule2"];
        actual = docCommand {
            DocArguments {
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
                currentWorkingDirectory = ".";
            };
        };
    };
}
