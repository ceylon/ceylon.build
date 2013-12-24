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
shared [String+] runJsCommand(RunJsArguments args) {
    value command = initCommand("run-js");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendOfflineMode(args.offline));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendRun(args.functionNameToRun));
    command.add(appendCompileOnRun(args.compileOnRun));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendDebug(args.debug));
    command.add(appendVerboseModes(args.verboseModes));
    command.add(appendPathToNodeJs(args.pathToNodeJs));
    command.addAll(appendArguments(args.arguments));
    command.add(appendModule(args.moduleName, args.version));
    command.addAll(appendModuleArguments(args.moduleArguments));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

"Builds a ceylon test command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] runTestsCommand(RunTestsArguments args) {
    value command = initCommand("test");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendNoDefaultRepositories(args.noDefaultRepositories));
    command.add(appendOfflineMode(args.offline));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendCompileOnRun(args.compileOnRun));
    command.add(appendTests(args.tests));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendArguments(args.arguments));
    command.addAll(appendCompilationUnits(args.modules));
    value sequence = command.coalesced.sequence;
    assert(nonempty sequence);
    return sequence;
}

MutableList<String?> initCommand(String tool) => ArrayList<String?> { initialCapacity = 2; tool };
