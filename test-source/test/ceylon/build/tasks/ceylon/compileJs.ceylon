import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { compileJsCommand, all, loader, AllVerboseModes, CompileJsVerboseMode }

test void shouldCreateCompileJsCommand() {
    assertEquals{
        expected = "compile-js mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithFiles() {
    assertEquals{
        expected = "compile-js file.ceylon";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = [];
                files = ["file.ceylon"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithEncoding() {
    assertEquals{
        expected = "compile-js --encoding=UTF-8 mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                encoding = "UTF-8";
            };
        };
    };
}
test void shouldCreateCompileJsCommandWithSourceDirectories() {
    assertEquals{
        expected = "compile-js --source=src-x --source=src-y mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                sourceDirectories = ["src-x", "src-y"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithOutputRepository() {
    assertEquals{
        expected = "compile-js --out=../modules mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                outputRepository = "../modules";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithRepositories() {
    assertEquals{
        expected = "compile-js --rep=../modules --rep=../../modules mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                repositories = ["../modules", "../../modules"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithSystemRepository() {
    assertEquals{
        expected = "compile-js --sysrep=~/.ceylon/repo mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                systemRepository = "~/.ceylon/repo";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithCacheRepository() {
    assertEquals{
        expected = "compile-js --cacherep=~/.ceylon/cache mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                cacheRepository = "~/.ceylon/cache";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithUser() {
    assertEquals{
        expected = "compile-js --user=john.doe mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                user = "john.doe";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithPassword() {
    assertEquals{
        expected = "compile-js --pass=Pa$$w0rd mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                password = "Pa$$w0rd";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithOffline() {
    assertEquals{
        expected = "compile-js --offline mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                offline = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithCompact() {
    assertEquals{
        expected = "compile-js --compact mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                compact = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithLexicalScopeStyle() {
    assertEquals{
        expected = "compile-js --lexical-scope-style mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                lexicalScopeStyle = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithNoComments() {
    assertEquals{
        expected = "compile-js --no-comments mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                noComments = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithNoIndent() {
    assertEquals{
        expected = "compile-js --no-indent mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                noIndent = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithNoModule() {
    assertEquals{
        expected = "compile-js --no-module mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                noModule = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithOptimize() {
    assertEquals{
        expected = "compile-js --optimize mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                optimize = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithProfile() {
    assertEquals{
        expected = "compile-js --profile mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                profile = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithSkipSourceArchive() {
    assertEquals{
        expected = "compile-js --skip-src-archive mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                skipSourceArchive = true;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithSystemProperties() {
    assertEquals{
        expected = "compile-js --define=KEY1=value1 --define=KEY2=value2 mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                systemProperties = ["KEY1" -> "value1", "KEY2" -> "value2"];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "compile-js --verbose mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithVerboseModes() {
    assertEquals{
        expected = "compile-js --verbose=all,loader mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                verboseModes = [all, loader];
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithCurrentWorkingDirectory() {
    assertEquals{
        expected = "compile-js --cwd=.. mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateCompileJsCommandWithArguments() {
    assertEquals{
        expected = "compile-js arg1 arg2=value mymodule";
        actual = callCompileJsCommand {
            CompileJsArguments {
                modules = ["mymodule"];
                arguments = ["arg1", "arg2=value"];
            };
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
        actual = callCompileJsCommand {
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
                arguments = ["--source=foo", "--source=bar"];
            };
        };
    };
}


class CompileJsArguments(
    modules,
    files = [],
    encoding = null,
    sourceDirectories = [],
    outputRepository = null,
    repositories = [],
    systemRepository = null,
    cacheRepository = null,
    user = null,
    password = null,
    offline = false,
    compact = false,
    lexicalScopeStyle = false,
    noComments = false,
    noIndent = false,
    noModule = false,
    optimize = false,
    profile = false,
    skipSourceArchive = false,
    systemProperties = [],
    verboseModes = [],
    currentWorkingDirectory = null,
    arguments = []) {
    "name of modules to compile"
    shared {String*} modules;
    "name of files to compile"
    shared {String*} files;
    "encoding used for reading source files
     (default: platform-specific)
     (corresponding command line parameter: `--encoding=<encoding>`)"
    shared String? encoding;
    "Path to source files
     (default: './source')
     (corresponding command line parameter: `--source=<dirs>`)"
    shared {String*} sourceDirectories;
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
    "Equivalent to '--no-indent' '--no-comments'
     (corresponding command line parameter: `--compact`)"
    shared Boolean compact;
    "Create lexical scope-style JS code
     (corresponding command line parameter: `--lexical-scope-style`)"
    shared Boolean lexicalScopeStyle;
    "Do NOT generate any comments
     (corresponding command line parameter: `--no-comments`)"
    shared Boolean noComments;
    "Do NOT indent code
     (corresponding command line parameter: `--no-indent`)"
    shared Boolean noIndent;
    "Do NOT wrap generated code as CommonJS module
     (corresponding command line parameter: `--no-module`)"
    shared Boolean noModule;
    "Create prototype-style JS code
     (corresponding command line parameter: `--optimize`)"
    shared Boolean optimize;
    "Time the compilation phases (results are printed to standard error)
     (corresponding command line parameter: `--profile`)"
    shared Boolean profile;
    "Do NOT generate .src archive - useful when doing joint compilation
     (corresponding command line parameter: `--skip-src-archive`)"
    shared Boolean skipSourceArchive;
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared {CompileJsVerboseMode*}|AllVerboseModes verboseModes;
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    shared String? currentWorkingDirectory;
    "custom arguments to be added to commandline"
    shared {String*} arguments;
}

String callCompileJsCommand(CompileJsArguments args) {
    return compileJsCommand {
        modules = args.modules;
        files = args.files;
        encoding = args.encoding;
        sourceDirectories = args.sourceDirectories;
        outputRepository = args.outputRepository;
        repositories = args.repositories;
        systemRepository = args.systemRepository;
        cacheRepository = args.cacheRepository;
        user = args.user;
        password = args.password;
        offline = args.offline;
        compact = args.compact;
        lexicalScopeStyle = args.lexicalScopeStyle;
        noComments = args.noComments;
        noIndent = args.noIndent;
        noModule = args.noModule;
        optimize = args.optimize;
        profile = args.profile;
        skipSourceArchive = args.skipSourceArchive;
        systemProperties = args.systemProperties;
        verboseModes = args.verboseModes;
        currentWorkingDirectory = args.currentWorkingDirectory;
        arguments = args.arguments;
    };
}