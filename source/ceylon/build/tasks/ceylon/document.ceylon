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
    command.addAll(appendCompilationUnits(args.modules));
    return cleanCommand(command);
}
