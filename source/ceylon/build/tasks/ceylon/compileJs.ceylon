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
    command.addAll(appendCompilationUnits(args.modules, args.files));
    return cleanCommand(command);
}
