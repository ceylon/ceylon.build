"Name of ceylon executable"
shared String ceylonExecutable = operatingSystem.name.lowercased.startsWith("windows") then "ceylon.bat" else "ceylon";

"Builds a ceylon compile command as a `String` and returns it."
shared String compileCommand(
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory,
        "name of modules to compile"
        {String*} modules,
        "name of files to compile"
        {String*} files,
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding,
        "Path to source files
         (default: './source')
         (corresponding command line parameter: `--source=<dirs>`)"
        {String*} sourceDirectories,
        "Path to directory containing resource files
         (default: './resource')
         (corresponding command line parameter: `--resource=<dirs>`)"
        {String*} resourceDirectories,
        "Passes an option to the underlying java compiler
         (corresponding command line parameter: `--javac=<option>`)"
        String? javacOptions,
        "Specifies the output module repository (which must be publishable).
         (default: './modules')
         (corresponding command line parameter: `--out=<url>`)"
        String? outputRepository,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        {String*} repositories,
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository,
        "Sets the user name for use with an authenticated output repository
         (corresponding command line parameter: `--user=<name>`)"
        String? user,
        "Sets the password for use with an authenticated output repository
         (corresponding command line parameter: `--pass=<secret>`)"
        String? password,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline,
        "Indicates that the default repositories should not be used
         (corresponding command line parameter: `--no-default-repositories`)"
        Boolean noDefaultRepositories,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties,
        "Indicates that the default repositories should not be used
         (corresponding command line parameter: `--no-default-repositories`)"
        {CompileVerboseMode*}|AllVerboseModes verboseModes,
        "custom arguments to be added to commandline"
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append("compile");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendResourceDirectories(sb, resourceDirectories);
    appendJavacOptions(sb, javacOptions);
    appendOutputRepository(sb, outputRepository);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendNoDefaultRepositories(sb, noDefaultRepositories);
    appendSystemProperties(sb, systemProperties);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    appendCompilationUnits(sb, modules, files);
    return sb.string;
}

"Builds a ceylon compile-js command as a `String` and returns it."
shared String compileJsCommand(
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory,
        "name of modules to compile"
        {String*} modules,
        "name of files to compile"
        {String*} files,
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding,
        "Path to source files
         (default: './source')
         (corresponding command line parameter: `--source=<dirs>`)"
        {String*} sourceDirectories,
        "Specifies the output module repository (which must be publishable).
         (default: './modules')
         (corresponding command line parameter: `--out=<url>`)"
        String? outputRepository,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        {String*} repositories,
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository,
        "Sets the user name for use with an authenticated output repository
         (corresponding command line parameter: `--user=<name>`)"
        String? user,
        "Sets the password for use with an authenticated output repository
         (corresponding command line parameter: `--pass=<secret>`)"
        String? password,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline,
        "Equivalent to '--no-indent' '--no-comments'
         (corresponding command line parameter: `--compact`)"
        Boolean compact,
        "Create lexical scope-style JS code
         (corresponding command line parameter: `--lexical-scope-style`)"
        Boolean lexicalScopeStyle,
        "Do NOT generate any comments
         (corresponding command line parameter: `--no-comments`)"
        Boolean noComments,
        "Do NOT indent code
         (corresponding command line parameter: `--no-indent`)"
        Boolean noIndent,
        "Do NOT wrap generated code as CommonJS module
         (corresponding command line parameter: `--no-module`)"
        Boolean noModule,
        "Create prototype-style JS code
         (corresponding command line parameter: `--optimize`)"
        Boolean optimize,
        "Time the compilation phases (results are printed to standard error)
         (corresponding command line parameter: `--profile`)"
        Boolean profile,
        "Do NOT generate .src archive - useful when doing joint compilation
         (corresponding command line parameter: `--skip-src-archive`)"
        Boolean skipSourceArchive,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties,
        "Produce verbose output.
         (corresponding command line parameter: `--verbose[=<flags>]`)"
        {CompileJsVerboseMode*}|AllVerboseModes verboseModes,
        "custom arguments to be added to commandline"
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append("compile-js");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendOutputRepository(sb, outputRepository);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendCompact(sb, compact);
    appendLexicalScopeStyle(sb, lexicalScopeStyle);
    appendNoComments(sb, noComments);
    appendNoIndent(sb, noIndent);
    appendNoModule(sb, noModule);
    appendOptimize(sb, optimize);
    appendProfile(sb, profile);
    appendSkipSourceArchive(sb, skipSourceArchive);
    appendSystemProperties(sb, systemProperties);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    appendCompilationUnits(sb, modules, files);
    return sb.string;
}

"Builds a ceylon doc command as a `String` and returns it."
shared String docCommand(
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory,
        "list of modules to document"
        {String+}  modules,
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding,
        "Path to source files
         (default: './source')
         (corresponding command line parameter: `--source=<dirs>`)"
        {String*} sourceDirectories,
        "A directory containing your module documentation
         (default: './doc')
         (corresponding command line parameter: `--doc=<dirs>`)"
        String? documentationDirectory,
        "Specifies the output module repository (which must be publishable).
         (default: './modules')
         (corresponding command line parameter: `--out=<url>`)"
        String? outputRepository,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        {String*} repositories,
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository,
        "Sets the user name for use with an authenticated output repository
         (corresponding command line parameter: `--user=<name>`)"
        String? user,
        "Sets the password for use with an authenticated output repository
         (corresponding command line parameter: `--pass=<secret>`)"
        String? password,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline,
        "The URL of a module repository containing documentation for external dependencies.
         
         Parameter url must be one of supported protocols (http://, https:// or file://).
         Parameter url can be prefixed with module name pattern, separated by a '=' character,
         determine for which external modules will be use.
         
         Examples:
         
         - --link https://modules.ceylon-lang.org/
         - --link ceylon.math=https://modules.ceylon-lang.org/
         
         (corresponding command line parameter: `--link=<url>`)"
        String? link,
        "Includes documentation for package-private declarations.
         (corresponding command line parameter: `--non-shared`)"
        Boolean includeNonShared,
        "Includes source code in the generated documentation.
         (corresponding command line parameter: `--source-code`)"
        Boolean includeSourceCode,
        "Do not print warnings about broken links.
         (corresponding command line parameter: `--ignore-broken-link`)"
        Boolean ignoreBrokenLink,
        "Do not print warnings about missing documentation.
         (corresponding command line parameter: `--ignore-missing-doc`)"
        Boolean ignoreMissingDoc,
        "Do not print warnings about missing throws annotation.
         (corresponding command line parameter: `--ignore-missing-throws`)"
        Boolean ignoreMissingThrows,
        "Sets the header text to be placed at the top of each page.
         (corresponding command line parameter: `--header=<header>`)"
        String? header,
        "Sets the footer text to be placed at the bottom of each page.
         (corresponding command line parameter: `--footer=<footer>`)"
        String? footer,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties,
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {DocVerboseMode*}|AllVerboseModes verboseModes,
        "custom arguments to be added to commandline"
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append("doc");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendDocumentationDirectory(sb, documentationDirectory);
    appendOutputRepository(sb, outputRepository);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendLink(sb, link);
    appendIncludeNonShared(sb, includeNonShared);
    appendIncludeSourceCode(sb, includeSourceCode);
    appendIgnoreBrokenLink(sb, ignoreBrokenLink);
    appendIgnoreMissingDoc(sb, ignoreMissingDoc);
    appendIgnoreMissingThrows(sb, ignoreMissingThrows);
    appendHeader(sb, header);
    appendFooter(sb, footer);
    appendSystemProperties(sb, systemProperties);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    appendCompilationUnits(sb, modules);
    return sb.string;
}

"Builds a ceylon run command as a `String` and returns it."
shared String runCommand(
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory,
        "name of module to run"
        String moduleName,
        "version of module to run"
        String? version,
        "Arguments to be passed to executed module"
        {String*} moduleArguments,
        "Indicates that the default repositories should not be used
         (corresponding command line parameter: `--no-default-repositories`)"
        Boolean noDefaultRepositories,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        {String*} repositories,
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository,
        "Specifies the fully qualified name of a toplevel method or class with no parameters.
         (corresponding command line parameter: `--run=<toplevel>`)"
        String? functionNameToRun,
        "Determines if and how compilation should be handled.
         (corresponding command line parameter: `--compile[=<flags>]`)"
        CompileOnRun? compileOnRun,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties,
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {RunVerboseMode*}|AllVerboseModes verboseModes,
        "custom arguments to be added to commandline"
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append("run");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendNoDefaultRepositories(sb, noDefaultRepositories);
    appendOfflineMode(sb, offline);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendRun(sb, functionNameToRun);
    appendCompileOnRun(sb, compileOnRun);
    appendSystemProperties(sb, systemProperties);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    appendModule(sb, moduleName, version);
    appendModuleArguments(sb, moduleArguments);
    return sb.string;
}

"Builds a ceylon run-js command as a `String` and returns it."
shared String runJsCommand(
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory,
        "name of module to run"
        String moduleName,
        "version of module to run"
        String? version,
        "Arguments to be passed to executed module"
        {String*} moduleArguments,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        {String*} repositories,
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository,
        "Specifies the fully qualified name of a toplevel method or class with no parameters.
         (corresponding command line parameter: `--run=<toplevel>`)"
        String? functionNameToRun,
        "Determines if and how compilation should be handled.
         (corresponding command line parameter: `--compile[=<flags>]`)"
        CompileOnRun? compileOnRun,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties,
        "Shows more detailed output in case of errors.
         (corresponding command line parameter: `--debug=<debug>`)"
        String? debug,
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {RunJsVerboseMode*}|AllVerboseModes verboseModes,
        "The path to the node.js executable. Will be searched in standard locations if not specified.
         (corresponding command line parameter: `--node-exe=<node-exe>`)"
        String? pathToNodeJs,
        "custom arguments to be added to commandline"
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append("run-js");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendOfflineMode(sb, offline);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendRun(sb, functionNameToRun);
    appendCompileOnRun(sb, compileOnRun);
    appendSystemProperties(sb, systemProperties);
    appendDebug(sb, debug);
    appendVerboseModes(sb, verboseModes);
    appendPathToNodeJs(sb, pathToNodeJs);
    appendArguments(sb, arguments);
    appendModule(sb, moduleName, version);
    appendModuleArguments(sb, moduleArguments);
    return sb.string;
}

"Builds a ceylon test command as a `String` and returns it."
shared String runTestsCommand(
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    String? currentWorkingDirectory,
    "name/version of modules to test"
    see(`function moduleVersion`)
    {String*} modules,
    "Specifies which tests will be run.
     (corresponding command line parameter: `--test=<test>`)"
    {String*} tests,
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    Boolean noDefaultRepositories,
    "Enables offline mode that will prevent the module loader from connecting to remote repositories.
     (corresponding command line parameter: `--offline`)"
    Boolean offline,
    "Specifies a module repository containing dependencies. Can be specified multiple times.
     (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
     (corresponding command line parameter: `--rep=<url>`)"
    {String*} repositories,
    "Specifies the system repository containing essential modules.
     (default: '$CEYLON_HOME/repo')
     (corresponding command line parameter: `--sysrep=<url>`)"
    String? systemRepository,
    "Specifies the folder to use for caching downloaded modules.
     (default: '~/.ceylon/cache')
     (corresponding command line parameter: `--cacherep=<url>`)"
    String? cacheRepository,
    "Determines if and how compilation should be handled.
     (corresponding command line parameter: `--compile[=<flags>]`)"
    CompileOnRun? compileOnRun,
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    {<String->String>*} systemProperties,
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    {RunTestsVerboseMode*}|AllVerboseModes verboseModes,
    "custom arguments to be added to commandline"
    {String*} arguments
) {
    StringBuilder sb = StringBuilder();
    sb.append("test");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendNoDefaultRepositories(sb, noDefaultRepositories);
    appendOfflineMode(sb, offline);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendCompileOnRun(sb, compileOnRun);
    appendTests(sb, tests);
    appendSystemProperties(sb, systemProperties);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    appendCompilationUnits(sb, modules);
    return sb.string;
}
