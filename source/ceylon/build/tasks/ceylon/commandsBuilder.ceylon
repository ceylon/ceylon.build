shared String buildCompileCommand(
        String ceylon,
        String moduleName,
        String? encoding,
        {String*} sourceDirectories,
        String? javacOptions,
        String? outputModuleRepository,
        String? dependenciesRepository,
        String? systemRepository,
        String? user,
        String? password,
        Boolean offline,
        Boolean disableModuleRepository,
        {CompileVerboseMode*} verboseModes,
        {String*} arguments
        ) {
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" compile");
    appendEncoding(sb, encoding);
    appendSourceDirectories(sb, sourceDirectories);
    appendJavacOptions(sb, javacOptions);
    appendOutputModuleRepository(sb, outputModuleRepository);
    appendDependenciesRepository(sb, dependenciesRepository);
    appendSystemRepository(sb, systemRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendDisableModuleRepository(sb, disableModuleRepository);
    appendVerboseModes(sb, verboseModes);
    appendArguments(sb, arguments);
    sb.append(" ");
    sb.append(moduleName);
    return sb.string;
}

shared String buildCompileJsCommand(
        String ceylon,
        String moduleName,
        String? encoding,
        {String*} sourceDirectories,
        String? outputModuleRepository,
        String? dependenciesRepository,
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
    appendOutputModuleRepository(sb, outputModuleRepository);
    appendDependenciesRepository(sb, dependenciesRepository);
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
    sb.append(moduleName);
    return sb.string;
}

shared String buildDocCommand(
        String ceylon,
        String moduleName,
        String? encoding,
        {String*} sourceDirectories,
        String? outputModuleRepository,
        String? dependenciesRepository,
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
    appendOutputModuleRepository(sb, outputModuleRepository);
    appendDependenciesRepository(sb, dependenciesRepository);
    appendSystemRepository(sb, systemRepository);
    appendUser(sb, user);
    appendPassword(sb, password);
    appendOfflineMode(sb, offline);
    appendLink(sb, link);
    appendIncludeNonShared(sb, includeNonShared);
    appendIncludeSourceCode(sb, includeSourceCode);
    appendArguments(sb, arguments);
    sb.append(" ");
    sb.append(moduleName);
    return sb.string;
}

shared String buildRunCommand(
        String ceylon,
        String moduleName,
        String version,
        Boolean disableModuleRepository,
        Boolean offline,
        String? dependenciesRepository,
        String? systemRepository,
        String? functionNameToRun,
        {RunVerboseMode*} verboseModes,
        {String*} arguments
        ) { 
    StringBuilder sb = StringBuilder();
    sb.append(ceylon);
    sb.append(" run");
    appendDisableModuleRepository(sb, disableModuleRepository);
    appendOfflineMode(sb, offline);
    appendDependenciesRepository(sb, dependenciesRepository);
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
        String? dependenciesRepository,
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
    appendDependenciesRepository(sb, dependenciesRepository);
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