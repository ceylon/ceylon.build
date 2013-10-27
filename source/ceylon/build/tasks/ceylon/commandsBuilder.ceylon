String ceylonExecutable = operatingSystem.name.lowercased.startsWith("windows") then "ceylon.bat" else "ceylon";

shared String buildCompileCommand(
        String ceylon,
        String? currentWorkingDirectory,
        {String+} compilationUnits,
        String? encoding,
        {String*} sourceDirectories,
        String? javacOptions,
        String? outputRepository,
        {String*} repositories,
        String? systemRepository,
        String? cacheRepository,
        String? user,
        String? password,
        Boolean offline,
        Boolean noDefaultRepositories,
        {CompileVerboseMode*}|AllVerboseModes verboseModes,
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" compile");
    appendCurrentWorkingDirectory(sb, currentWorkingDirectory);
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendJavacOptions(sb, javacOptions);
    appendOutputRepository(sb, outputRepository);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendCacheRepository(sb, cacheRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendNoDefaultRepositories(sb, noDefaultRepositories);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    sb.append(" ");
    sb.append(" ".join(compilationUnits));
    return sb.string;
}

shared String buildCompileJsCommand(
        String ceylon,
        {String+} compilationUnits,
        String? encoding,
        {String*} sourceDirectories,
        String? outputRepository,
        {String*} repositories,
        String? systemRepository,
        String? user,
        String? password,
        Boolean offline,
        Boolean compact,
        Boolean noComments,
        Boolean noIndent,
        Boolean noModule,
        Boolean optimize,
        Boolean profile,
        Boolean skipSourceArchive,
        Boolean verbose,
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" compile-js");
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendOutputRepository(sb, outputRepository);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendCompact(sb, compact);
    appendNoComments(sb, noComments);
    appendNoIndent(sb, noIndent);
    appendNoModule(sb, noModule);
    appendOptimize(sb, optimize);
    appendProfile(sb, profile);
    appendSkipSourceArchive(sb, skipSourceArchive);
    appendVerbose(sb, verbose);
    appendArguments(sb, arguments);
    sb.append(" ");
    sb.append(" ".join(compilationUnits));
    return sb.string;
}

shared String buildDocCommand(
        String ceylon,
        {String+}  modules,
        String? encoding,
        {String*} sourceDirectories,
        String? outputRepository,
        {String*} repositories,
        String? systemRepository,
        String? user,
        String? password,
        Boolean offline,
        String? link,
        Boolean includeNonShared,
        Boolean includeSourceCode,
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" doc");
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendOutputRepository(sb, outputRepository);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendLink(sb, link);
    appendIncludeNonShared(sb, includeNonShared);
    appendIncludeSourceCode(sb, includeSourceCode);
    appendArguments(sb, arguments);
    sb.append(" ");
    sb.append(" ".join(modules));
    return sb.string;
}

shared String buildRunCommand(
        String ceylon,
        String moduleName,
        String version,
        Boolean noDefaultRepositories,
        Boolean offline,
        {String*} repositories,
        String? systemRepository,
        String? functionNameToRun,
        {RunVerboseMode*}|AllVerboseModes verboseModes,
        {String*} arguments
        ) { 
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" run");
    appendNoDefaultRepositories(sb, noDefaultRepositories);
    appendOfflineMode(sb, offline);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendRun(sb, functionNameToRun);
    appendVerboseModes(sb, verboseModes);
    sb.append(" ");
    sb.append(moduleName);
    sb.append("/");
    sb.append(version);
    appendArguments(sb, arguments);
    return sb.string;
}

shared String buildRunJsCommand(
        String ceylon,
        String moduleName,
        String version,
        Boolean offline,
        {String*} repositories,
        String? systemRepository,
        String? functionNameToRun,
        String? debug,
        String? pathToNodeJs,
        {String*} arguments
        ) { 
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" run-js");
    appendOfflineMode(sb, offline);
    appendRepositories(sb, repositories);
    appendSystemRepository(sb, systemRepository);
    appendRun(sb, functionNameToRun);
    appendDebug(sb, debug);
    appendPathToNodeJs(sb, pathToNodeJs);
    sb.append(" ");
    sb.append(moduleName);
    sb.append("/");
    sb.append(version);
    appendArguments(sb, arguments);
    return sb.string;
}