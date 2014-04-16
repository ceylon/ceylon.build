"Builds a ceylon test command as a `[String+]` and returns it.
 
 First element of returned sequence is the tool name.
 Next elements are tool arguments."
shared [String+] testCommand(TestArguments args) {
    value command = initCommand("test");
    command.add(appendCurrentWorkingDirectory(args.currentWorkingDirectory));
    command.add(appendNoDefaultRepositories(args.noDefaultRepositories));
    command.add(appendOfflineMode(args.offline));
    command.addAll(appendRepositories(args.repositories));
    command.add(appendSystemRepository(args.systemRepository));
    command.add(appendCacheRepository(args.cacheRepository));
    command.add(appendCompileOnRun(args.compileOnRun));
    command.addAll(appendTests(args.tests));
    command.addAll(appendSystemProperties(args.systemProperties));
    command.add(appendVerboseModes(args.verboseModes));
    command.addAll(appendCompilationUnits(args.modules));
    return cleanCommand(command);
}
