import ceylon.collection { ArrayList, MutableList }

"Name of ceylon executable"
shared String ceylonExecutable = operatingSystem.name.lowercased.startsWith("windows") then "ceylon.bat" else "ceylon";

"Builds a ceylon compile command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] compileCommand(CompileArguments args) {
    value command = initCommand("compile");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendEncoding(args.encoding));
    command.addAll(appendSourceDirectories(args.sourceDirectories));
    command.addAll(appendResourceDirectories(args.resourceDirectories));
    command.add(appendJavacOptions(args.javacOptions));
    command.add(appendOutputRepository(args.outputRepository));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendUser(args.user));
    command.add(appendPassword(args.password));
    command.add(appendOfflineMode(args.offline));
    command.add(appendNoDefaultRepositories(args.noDefaultRepositories));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendArguments(args.arguments));
    command.addAll(appendCompilationUnits(args.modules, args.files));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

"Builds a ceylon compile-js command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] compileJsCommand(CompileJsArguments args) {
    value command = initCommand("compile-js");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendEncoding(args.encoding));
    command.addAll(appendSourceDirectories(args.sourceDirectories));
    command.add(appendOutputRepository(args.outputRepository));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendUser(args.user));
    command.add(appendPassword(args.password));
    command.add(appendOfflineMode(args.offline));
    command.add(appendCompact(args.compact));
    command.add(appendLexicalScopeStyle(args.lexicalScopeStyle));
    command.add(appendNoComments(args.noComments));
    command.add(appendNoIndent(args.noIndent));
    command.add(appendNoModule(args.noModule));
    command.add(appendOptimize(args.optimize));
    command.add(appendProfile(args.profile));
    command.add(appendSkipSourceArchive(args.skipSourceArchive));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendArguments(args.arguments));
    command.addAll(appendCompilationUnits(args.modules, args.files));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

"Builds a ceylon doc command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] docCommand(DocArguments args) {
    value command = initCommand("doc");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendEncoding(args.encoding));
    command.addAll(appendSourceDirectories(args.sourceDirectories));
    command.add(appendDocumentationDirectory(args.documentationDirectory));
    command.add(appendOutputRepository(args.outputRepository));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendUser(args.user));
    command.add(appendPassword(args.password));
    command.add(appendOfflineMode(args.offline));
    command.add(appendLink(args.link));
    command.add(appendIncludeNonShared(args.includeNonShared));
    command.add(appendIncludeSourceCode(args.includeSourceCode));
    command.add(appendIgnoreBrokenLink(args.ignoreBrokenLink));
    command.add(appendIgnoreMissingDoc(args.ignoreMissingDoc));
    command.add(appendIgnoreMissingThrows(args.ignoreMissingThrows));
    command.add(appendHeader(args.header));
    command.add(appendFooter(args.footer));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendArguments(args.arguments));
    command.addAll(appendCompilationUnits(args.modules));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

"Builds a ceylon run command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] runCommand(RunArguments args) {
    value command = initCommand("run");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendNoDefaultRepositories(args.noDefaultRepositories));
    command.add(appendOfflineMode(args.offline));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendRun(args.functionNameToRun));
    command.add(appendCompileOnRun(args.compileOnRun));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendArguments(args.arguments));
    command.add(appendModule(args.moduleName, args.version));
    command.addAll(appendModuleArguments(args.moduleArguments));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

"Builds a ceylon run-js command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] runJsCommand(
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
    value command = initCommand("run-js");
    command.add(appendCurrentWorkingDirectory(currentWorkingDirectory));
    command.add(appendOfflineMode(offline));
    command.addAll(appendRepositories(repositories));
    command.add(appendSystemRepository(systemRepository));
    command.add(appendCacheRepository(cacheRepository));
    command.add(appendRun(functionNameToRun));
    command.add(appendCompileOnRun(compileOnRun));
    command.addAll(appendSystemProperties(systemProperties));
    command.add(appendDebug(debug));
    command.add(appendVerboseModes(verboseModes));
    command.add(appendPathToNodeJs(pathToNodeJs));
    command.addAll(appendArguments(arguments));
    command.add(appendModule(moduleName, version));
    command.addAll(appendModuleArguments(moduleArguments));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

"Builds a ceylon test command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] runTestsCommand(
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
    value command = initCommand("test");
    command.add(appendCurrentWorkingDirectory(currentWorkingDirectory));
    command.add(appendNoDefaultRepositories(noDefaultRepositories));
    command.add(appendOfflineMode(offline));
    command.addAll(appendRepositories(repositories));
    command.add(appendSystemRepository(systemRepository));
    command.add(appendCacheRepository(cacheRepository));
    command.add(appendCompileOnRun(compileOnRun));
    command.add(appendTests(tests));
    command.addAll(appendSystemProperties(systemProperties));
    command.add(appendVerboseModes(verboseModes));
    command.addAll(appendArguments(arguments));
    command.addAll(appendCompilationUnits(modules));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

MutableList<String?> initCommand(String tool) => ArrayList<String?> { initialCapacity = 2; tool };
