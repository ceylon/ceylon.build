import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { CompileJsArguments, compileJsCommand, all, loader}

test void shouldCreateCompileJsCommand() {
    assertEquals {
        expected = ["compile-js", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithFiles() {
    assertEquals {
        expected = ["compile-js", "file.ceylon"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = [];
                files = ["file.ceylon"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithEncoding() {
    assertEquals {
        expected = ["compile-js", "--encoding=UTF-8", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                encoding = "UTF-8";
            };
        };
    };
}
test void shouldCreateCompileJsCommandWithSourceDirectories() {
    assertEquals {
        expected = ["compile-js", "--source=src-x", "--source=src-y", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                sourceDirectories = ["src-x", "src-y"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithOutputRepository() {
    assertEquals {
        expected = ["compile-js", "--out=../modules", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                outputRepository = "../modules";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithRepositories() {
    assertEquals {
        expected = ["compile-js", "--rep=../modules", "--rep=../../modules", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                repositories = ["../modules", "../../modules"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithSystemRepository() {
    assertEquals {
        expected = ["compile-js", "--sysrep=~/.ceylon/repo", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                systemRepository = "~/.ceylon/repo";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithCacheRepository() {
    assertEquals {
        expected = ["compile-js", "--cacherep=~/.ceylon/cache", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                cacheRepository = "~/.ceylon/cache";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithUser() {
    assertEquals {
        expected = ["compile-js", "--user=john.doe", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                user = "john.doe";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithPassword() {
    assertEquals {
        expected = ["compile-js", "--pass=Pa$$w0rd", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                password = "Pa$$w0rd";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithOffline() {
    assertEquals {
        expected = ["compile-js", "--offline", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                offline = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithCompact() {
    assertEquals {
        expected = ["compile-js", "--compact", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                compact = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithLexicalScopeStyle() {
    assertEquals {
        expected = ["compile-js", "--lexical-scope-style", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                lexicalScopeStyle = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithNoComments() {
    assertEquals {
        expected = ["compile-js", "--no-comments", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                noComments = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithNoIndent() {
    assertEquals {
        expected = ["compile-js", "--no-indent", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                noIndent = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithNoModule() {
    assertEquals {
        expected = ["compile-js", "--no-module", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                noModule = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithOptimize() {
    assertEquals {
        expected = ["compile-js", "--optimize", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                optimize = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithProfile() {
    assertEquals {
        expected = ["compile-js", "--profile", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                profile = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithSkipSourceArchive() {
    assertEquals {
        expected = ["compile-js", "--skip-src-archive", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                skipSourceArchive = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithSystemProperties() {
    assertEquals {
        expected = ["compile-js", "--define=KEY1=value1", "--define=KEY2=value2", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                systemProperties = ["KEY1" -> "value1", "KEY2" -> "value2"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["compile-js", "--verbose", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithVerboseModes() {
    assertEquals {
        expected = ["compile-js", "--verbose=all,loader", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                verboseModes = [all, loader];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithCurrentWorkingDirectory() {
    assertEquals {
        expected = ["compile-js", "--cwd=..", "mymodule"];
        actual = compileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["compile-js", "--cwd=.", "--encoding=UTF-8", "--source=source-a", "--source=source-b",
        "--out=~/.ceylon/repo", "--rep=dependencies1", "--rep=dependencies2", "--sysrep=system-repository",
        "--cacherep=cache-rep", "--user=ceylon-user", "--pass=ceylon-user-password", "--offline",
        "--compact", "--lexical-scope-style", "--no-comments", "--no-indent", "--no-module", "--optimize",
        "--profile", "--skip-src-archive", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo", "--verbose",
        "module1", "module2", "file1.js", "file2.js"];
        actual = compileJsCommand {
            CompileJsArguments {
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
                verboseModes = all;
                currentWorkingDirectory = ".";
            };
        };
    };
}
