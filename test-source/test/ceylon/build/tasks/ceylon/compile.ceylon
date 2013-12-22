import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { compileCommand, all, loader, cmr, benchmark, code, ast, CompileVerboseMode, AllVerboseModes }

test void shouldCreateCompileCommand() {
    assertEquals{
        expected = "compile mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithFiles() {
    assertEquals{
        expected = "compile file.ceylon";
        actual = callCompileCommand {
            CompileArguments {
                modules = [];
                files = ["file.ceylon"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithEncoding() {
    assertEquals{
        expected = "compile --encoding=UTF-8 mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                encoding = "UTF-8";
            };
        };
    };
}
test void shouldCreateCompileCommandWithSourceDirectories() {
    assertEquals{
        expected = "compile --source=src-x --source=src-y mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                sourceDirectories = ["src-x", "src-y"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithResourceDirectories() {
    assertEquals{
        expected = "compile --resource=res-x --resource=res-y mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                resourceDirectories = ["res-x", "res-y"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithJavacOptions() {
    assertEquals{
        expected = "compile --javac=-Xmx512m mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                javacOptions = "-Xmx512m";
            };
        };
    };
}

test void shouldCreateCompileCommandWithOutputRepository() {
    assertEquals{
        expected = "compile --out=../modules mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                outputRepository = "../modules";
            };
        };
    };
}

test void shouldCreateCompileCommandWithRepositories() {
    assertEquals{
        expected = "compile --rep=../modules --rep=../../modules mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                repositories = ["../modules", "../../modules"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithSystemRepository() {
    assertEquals{
        expected = "compile --sysrep=~/.ceylon/repo mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                systemRepository = "~/.ceylon/repo";
            };
        };
    };
}

test void shouldCreateCompileCommandWithCacheRepository() {
    assertEquals{
        expected = "compile --cacherep=~/.ceylon/cache mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                cacheRepository = "~/.ceylon/cache";
            };
        };
    };
}

test void shouldCreateCompileCommandWithUser() {
    assertEquals{
        expected = "compile --user=john.doe mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                user = "john.doe";
            };
        };
    };
}

test void shouldCreateCompileCommandWithPassword() {
    assertEquals{
        expected = "compile --pass=Pa$$w0rd mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                password = "Pa$$w0rd";
            };
        };
    };
}

test void shouldCreateCompileCommandWithOffline() {
    assertEquals{
        expected = "compile --offline mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                offline = true;
            };
        };
    };
}

test void shouldCreateCompileCommandWithNoDefaultRepositories() {
    assertEquals{
        expected = "compile --no-default-repositories mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                noDefaultRepositories = true;
            };
        };
    };
}

test void shouldCreateCompileCommandWithSystemProperties() {
    assertEquals{
        expected = "compile --define=KEY1=value1 --define=KEY2=value2 mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                systemProperties = ["KEY1" -> "value1", "KEY2" -> "value2"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithVerboseModes() {
    assertEquals{
        expected = "compile --verbose=all,loader,ast,code,cmr,benchmark mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                verboseModes = [all, loader, ast, code, cmr, benchmark];
            };
        };
    };
}

test void shouldCreateCompileCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "compile --verbose mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                verboseModes = all;
            };
        };
    };
}

test void shouldCreateCompileCommandWithCurrentWorkingDirectory() {
    assertEquals{
        expected = "compile --cwd=.. mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                currentWorkingDirectory = "..";
            };
        };
    };
}

test void shouldCreateCompileCommandWithArguments() {
    assertEquals{
        expected = "compile arg1 arg2=value mymodule";
        actual = callCompileCommand {
            CompileArguments {
                modules = ["mymodule"];
                arguments = ["arg1", "arg2=value"];
            };
        };
    };
}

test void shouldCreateCompileCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "compile --cwd=. --encoding=UTF-8 --source=source-a --source=source-b" +
                " --resource=resource-a --resource=resource-c" +
                " --javac=-g:source,lines,vars --out=~/.ceylon/repo --rep=dependencies" +
                " --sysrep=system-repository --cacherep=cache-rep --user=ceylon-user --pass=ceylon-user-password" +
                " --offline --no-default-repositories" +
                " --define=ENV_VAR1=42 --define=ENV_VAR2=foo --verbose=loader,ast,code,cmr,benchmark" +
                " --source=foo --source=bar module1 module2 file1.ceylon file2.ceylon";
        actual = callCompileCommand {
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

class CompileArguments(
    modules,
    files = [],
    encoding = null,
    sourceDirectories = [],
    resourceDirectories = [],
    javacOptions = null,
    outputRepository = null,
    repositories = [],
    systemRepository = null,
    cacheRepository = null,
    user = null,
    password = null,
    offline = false,
    noDefaultRepositories = false,
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
    "Path to directory containing resource files
     (default: './resource')
     (corresponding command line parameter: `--resource=<dirs>`)"
    shared {String*} resourceDirectories;
    "Passes an option to the underlying java compiler
     (corresponding command line parameter: `--javac=<option>`)"
    shared String? javacOptions;
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
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared Boolean noDefaultRepositories;
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared {CompileVerboseMode*}|AllVerboseModes verboseModes;
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    shared String? currentWorkingDirectory;
    "custom arguments to be added to commandline"
    shared {String*} arguments;
}

String callCompileCommand(CompileArguments args) {
    return compileCommand {
        modules = args.modules;
        files = args.files;
        encoding = args.encoding;
        sourceDirectories = args.sourceDirectories;
        resourceDirectories = args.resourceDirectories;
        javacOptions = args.javacOptions;
        outputRepository = args.outputRepository;
        repositories = args.repositories;
        systemRepository = args.systemRepository;
        cacheRepository = args.cacheRepository;
        user = args.user;
        password = args.password;
        offline = args.offline;
        noDefaultRepositories = args.noDefaultRepositories;
        systemProperties = args.systemProperties;
        verboseModes = args.verboseModes;
        currentWorkingDirectory = args.currentWorkingDirectory;
        arguments = args.arguments;
    };
}
