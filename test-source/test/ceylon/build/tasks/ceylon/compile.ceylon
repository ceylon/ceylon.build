import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { CompileArguments, compileCommand, all, loader, cmr, benchmark, code, ast }

test void shouldCreateCompileCommand() {
    assertEquals {
        expected = ["compile", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithFiles() {
    assertEquals {
        expected = ["compile", "file.ceylon"];
        actual = compileCommand {
            CompileArguments {
                modules = [];
                files = ["file.ceylon"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithEncoding() {
    assertEquals {
        expected = ["compile", "--encoding=UTF-8", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                encoding = "UTF-8";
            };
        };
    };
}
test void shouldCreateCompileCommandWithSourceDirectories() {
    assertEquals {
        expected = ["compile", "--source=src-x", "--source=src-y", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                sourceDirectories = ["src-x", "src-y"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithResourceDirectories() {
    assertEquals {
        expected = ["compile", "--resource=res-x", "--resource=res-y", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                resourceDirectories = ["res-x", "res-y"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithJavacOptions() {
    assertEquals {
        expected = ["compile", "--javac=-Xmx512m", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                javacOptions = "-Xmx512m";
            };
        };
    };
}

test void shouldCreateCompileCommandWithOutputRepository() {
    assertEquals {
        expected = ["compile", "--out=../modules", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                outputRepository = "../modules";
            };
        };
    };
}

test void shouldCreateCompileCommandWithRepositories() {
    assertEquals {
        expected = ["compile", "--rep=../modules", "--rep=../../modules", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                repositories = ["../modules", "../../modules"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithSystemRepository() {
    assertEquals {
        expected = ["compile", "--sysrep=~/.ceylon/repo", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                systemRepository = "~/.ceylon/repo";
            };
        };
    };
}

test void shouldCreateCompileCommandWithCacheRepository() {
    assertEquals {
        expected = ["compile", "--cacherep=~/.ceylon/cache", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                cacheRepository = "~/.ceylon/cache";
            };
        };
    };
}

test void shouldCreateCompileCommandWithUser() {
    assertEquals {
        expected = ["compile", "--user=john.doe", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                user = "john.doe";
            };
        };
    };
}

test void shouldCreateCompileCommandWithPassword() {
    assertEquals {
        expected = ["compile", "--pass=Pa$$w0rd", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                password = "Pa$$w0rd";
            };
        };
    };
}

test void shouldCreateCompileCommandWithOffline() {
    assertEquals {
        expected = ["compile", "--offline", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                offline = true;
            };
        };
    };
}

test void shouldCreateCompileCommandWithNoDefaultRepositories() {
    assertEquals {
        expected = ["compile", "--no-default-repositories", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                noDefaultRepositories = true;
            };
        };
    };
}

test void shouldCreateCompileCommandWithSystemProperties() {
    assertEquals {
        expected = ["compile", "--define=KEY1=value1", "--define=KEY2=value2", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                systemProperties = ["KEY1" -> "value1", "KEY2" -> "value2"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithVerboseModes() {
    assertEquals {
        expected = ["compile", "--verbose=all,loader,ast,code,cmr,benchmark", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                verboseModes = [all, loader, ast, code, cmr, benchmark];
            };
        };
    };
}

test void shouldCreateCompileCommandWithAllVerboseFlag() {
    assertEquals {
        expected = ["compile", "--verbose", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateCompileCommandWithCurrentWorkingDirectory() {
    assertEquals {
        expected = ["compile", "--cwd=..", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateCompileCommandWithArguments() {
    assertEquals {
        expected = ["compile", "arg1", "arg2=value", "mymodule"];
        actual = compileCommand {
            CompileArguments {
                modules = ["mymodule"];
                arguments = ["arg1", "arg2=value"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithAllParametersSpecified() {
    assertEquals {
        expected = ["compile", "--cwd=.", "--encoding=UTF-8", "--source=source-a", "--source=source-b",
            "--resource=resource-a", "--resource=resource-c", "--javac=-g:source,lines,vars",
            "--out=~/.ceylon/repo", "--rep=dependencies", "--sysrep=system-repository",
            "--cacherep=cache-rep", "--user=ceylon-user", "--pass=ceylon-user-password", "--offline",
            "--no-default-repositories", "--define=ENV_VAR1=42", "--define=ENV_VAR2=foo",
            "--verbose=loader,ast,code,cmr,benchmark", "--source=foo", "--source=bar", "module1",
            "module2", "file1.ceylon", "file2.ceylon"];
        actual = compileCommand {
            CompileArguments {
                currentWorkingDirectory = ".";
                modules = ["module1", "module2"];
                files = ["file1.ceylon", "file2.ceylon"];
                encoding = "UTF-8";
                sourceDirectories = ["source-a", "source-b"];
                resourceDirectories = ["resource-a", "resource-c"];
                javacOptions = "-g:source,lines,vars";
                outputRepository = "~/.ceylon/repo";
                repositories = ["dependencies"];
                systemRepository = "system-repository";
                cacheRepository = "cache-rep";
                user = "ceylon-user";
                password = "ceylon-user-password";
                offline = true;
                noDefaultRepositories = true;
                systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
                verboseModes = [loader, ast, code, cmr, benchmark];
                arguments = ["--source=foo", "--source=bar"];
            };
        };
    };
}
