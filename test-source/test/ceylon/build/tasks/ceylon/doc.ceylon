import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { docCommand, all, loader, DocVerboseMode, AllVerboseModes }

test void shouldCreateDocCommand() {
    assertEquals {
        expected = ["doc", "mymodule"];
        actual = callDocCommand {
            DocArguments {
                modules = ["mymodule"];
            };
        };
    };
}

test void shouldCreatedocCommandWithEncoding() {
    assertEquals {
        expected = ["doc", "--encoding=UTF-8", "mymodule"];
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
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
        actual = callDocCommand {
            DocArguments {
                modules = ["mymodule"];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreatedocCommandWithArguments() {
    assertEquals {
        expected = ["doc", "arg1", "arg2=value", "mymodule"];
        actual = callDocCommand {
            DocArguments {
                modules = ["mymodule"];
                arguments = ["arg1", "arg2=value"];
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
        "--define=ENV_VAR2=foo", "--verbose=all,loader", "--source=foo", "--source=bar", "mymodule1", "mymodule2"];
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

class DocArguments(
    modules,
    encoding = null,
    sourceDirectories = [],
    documentationDirectory = null,
    outputRepository = null,
    repositories = [],
    systemRepository = null,
    cacheRepository = null,
    user = null,
    password = null,
    offline = false,
    link = null,
    includeNonShared = false,
    includeSourceCode = false,
    ignoreBrokenLink = false,
    ignoreMissingDoc = false,
    ignoreMissingThrows = false,
    header = null,
    footer = null,
    systemProperties = [],
    verboseModes = [],
    currentWorkingDirectory = null,
    arguments = []) {
    "name of modules to doc"
    shared {String+} modules;
    "encoding used for reading source files
     (default: platform-specific)
     (corresponding command line parameter: `--encoding=<encoding>`)"
    shared String? encoding;
    "Path to source files
     (default: './source')
     (corresponding command line parameter: `--source=<dirs>`)"
    shared {String*} sourceDirectories;
    "A directory containing your module documentation
     (default: './doc')
     (corresponding command line parameter: `--doc=<dirs>`)"
    shared String? documentationDirectory;
    "Specifies the output module repository (which must be publishable).
     (default: './modules')
     (corresponding command line parameter: `--out=<url>`)"
    shared String? outputRepository;
    "Specifies a module repository containing dependencies. Can be specified multiple times.
     (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
     (corresponding command line parameter: `--rep=<url>`)"
    shared {String*} repositories;
    "Specifies the system repository containing essential modules.
     (default: '$CEYLON_HOME/repo')
     (corresponding command line parameter: `--sysrep=<url>`)"
    shared String? systemRepository;
    "Specifies the folder to use for caching downloaded modules.
     (default: '~/.ceylon/cache')
     (corresponding command line parameter: `--cacherep=<url>`)"
    shared String? cacheRepository;
    "Sets the user name for use with an authenticated output repository
     (corresponding command line parameter: `--user=<name>`)"
    shared String? user;
    "Sets the password for use with an authenticated output repository
     (corresponding command line parameter: `--pass=<secret>`)"
    shared String? password;
    "Enables offline mode that will prevent the module loader from connecting to remote repositories.
     (corresponding command line parameter: `--offline`)"
    shared Boolean offline;
    "The URL of a module repository containing documentation for external dependencies.
     
     Parameter url must be one of supported protocols (http://, https:// or file://).
     Parameter url can be prefixed with module name pattern, separated by a '=' character,
     determine for which external modules will be use.
     
     Examples:
     
     - --link https://modules.ceylon-lang.org/
     - --link ceylon.math=https://modules.ceylon-lang.org/
     
     (corresponding command line parameter: `--link=<url>`)"
    shared String? link;
    "Includes documentation for package-private declarations.
     (corresponding command line parameter: `--non-shared`)"
    shared Boolean includeNonShared;
    "Includes source code in the generated documentation.
     (corresponding command line parameter: `--source-code`)"
    shared Boolean includeSourceCode;
    "Do not print warnings about broken links.
     (corresponding command line parameter: `--ignore-broken-link`)"
    shared Boolean ignoreBrokenLink;
    "Do not print warnings about missing documentation.
     (corresponding command line parameter: `--ignore-missing-doc`)"
    shared Boolean ignoreMissingDoc;
    "Do not print warnings about missing throws annotation.
     (corresponding command line parameter: `--ignore-missing-throws`)"
    shared Boolean ignoreMissingThrows;
    "Sets the header text to be placed at the top of each page.
     (corresponding command line parameter: `--header=<header>`)"
    shared String? header;
    "Sets the footer text to be placed at the bottom of each page.
     (corresponding command line parameter: `--footer=<footer>`)"
    shared String? footer;
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    shared String? currentWorkingDirectory;
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    shared {DocVerboseMode*}|AllVerboseModes verboseModes;
    "custom arguments to be added to commandline"
    shared {String*} arguments;
}

[String+] callDocCommand(DocArguments args) {
    return docCommand {
        modules = args.modules;
        encoding = args.encoding;
        sourceDirectories = args.sourceDirectories;
        documentationDirectory = args.documentationDirectory;
        outputRepository = args.outputRepository;
        repositories = args.repositories;
        systemRepository = args.systemRepository;
        cacheRepository = args.cacheRepository;
        user = args.user;
        password = args.password;
        offline = args.offline;
        link = args.link;
        includeNonShared = args.includeNonShared;
        includeSourceCode = args.includeSourceCode;
        ignoreBrokenLink = args.ignoreBrokenLink;
        ignoreMissingDoc = args.ignoreMissingDoc;
        ignoreMissingThrows = args.ignoreMissingThrows;
        header = args.header;
        footer = args.footer;
        systemProperties = args.systemProperties;
        verboseModes = args.verboseModes;
        currentWorkingDirectory = args.currentWorkingDirectory;
        arguments = args.arguments;
    };
}
