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
    command.add(appendModule(args.moduleName, args.version));
    command.addAll(appendModuleArguments(args.moduleArguments));
    return cleanCommand(command);
}
