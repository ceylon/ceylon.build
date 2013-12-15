void appendCurrentWorkingDirectory(StringBuilder sb, String? currentWorkingDirectory) {
    appendParameter(sb, "cwd", currentWorkingDirectory);
}

void appendEncoding(StringBuilder sb, String? encoding) {
    appendParameter(sb, "encoding", encoding);
}

void appendJavacOptions(StringBuilder sb, String? javacOptions) {
    appendParameter(sb, "javac", javacOptions);
}

void appendOutputRepository(StringBuilder sb, String? outputRepository) {
    appendParameter(sb, "out", outputRepository);
}

void appendRepositories(StringBuilder sb, {String*} repositories) {
    for (repository in repositories) {
        appendParameter(sb, "rep", repository);
    }
}

void appendSourceDirectories(StringBuilder sb, {String*} sourceDirectories) {
    for (sourceDirectory in sourceDirectories) {
        appendParameter(sb, "source", sourceDirectory);
    }
}

void appendResourceDirectories(StringBuilder sb, {String*} resourceDirectories) {
    for (resourceDirectory in resourceDirectories) {
        appendParameter(sb, "resource", resourceDirectory);
    }
}

void appendSystemRepository(StringBuilder sb, String? systemRepository) {
    appendParameter(sb, "sysrep", systemRepository);
}

void appendCacheRepository(StringBuilder sb, String? cacheRepository) {
    appendParameter(sb, "cacherep", cacheRepository);
}

void appendUser(StringBuilder sb, String? user) {
    appendParameter(sb, "user", user);
}

void appendPassword(StringBuilder sb, String? password) {
    appendParameter(sb, "pass", password);
}

void appendNoDefaultRepositories(StringBuilder sb, Boolean noDefaultRepositories) {
    appendFlag(sb, "no-default-repositories", noDefaultRepositories);
}

void appendOfflineMode(StringBuilder sb, Boolean offline) {
    appendFlag(sb, "offline", offline);
}

void appendSystemProperties(StringBuilder sb, {<String->String>*} systemProperties) {
    for (systemProperty in systemProperties) {
        appendParameter(sb, "define", "``systemProperty.key``=``systemProperty.item``");
    }
}

void appendVerboseModes(StringBuilder sb, {<CompileVerboseMode|RunVerboseMode>*}|AllVerboseModes verboseModes) {
    if (is {<CompileVerboseMode|RunVerboseMode>*} verboseModes) {
        appendList(sb, "verbose", verboseModes);
    } else {
        appendFlag(sb, "verbose");
    }
}

void appendCompilationUnits(StringBuilder sb, {String*} modules, {String*} files) {
    sb.append(" ");
    sb.append(" ".join(concatenate(modules, files)));
}

void appendCompact(StringBuilder sb, Boolean compact) {
    appendFlag(sb, "compact", compact);
}

void appendLexicalScopeStyle(StringBuilder sb, Boolean lexicalScopeStyle) {
    appendFlag(sb, "lexical-scope-style", lexicalScopeStyle);
}

void appendNoComments(StringBuilder sb, Boolean noComments) {
    appendFlag(sb, "no-comments", noComments);
}

void appendNoIndent(StringBuilder sb, Boolean noIndent) {
    appendFlag(sb, "no-indent", noIndent);
}

void appendNoModule(StringBuilder sb, Boolean noModule) {
    appendFlag(sb, "no-module", noModule);
}

void appendOptimize(StringBuilder sb, Boolean optimize) {
    appendFlag(sb, "optimize", optimize);
}

void appendProfile(StringBuilder sb, Boolean profile) {
    appendFlag(sb, "profile", profile);
}

void appendSkipSourceArchive(StringBuilder sb, Boolean skipSourceArchive) {
    appendFlag(sb, "skip-src-archive", skipSourceArchive);
}

void appendVerbose(StringBuilder sb, Boolean verbose) {
    appendFlag(sb, "verbose", verbose);
}

void appendLink(StringBuilder sb, String? link) {
    appendParameter(sb, "link", link);
}

void appendIncludeNonShared(StringBuilder sb, Boolean includeNonShared) {
    appendFlag(sb, "non-shared", includeNonShared);
}

void appendIncludeSourceCode(StringBuilder sb, Boolean includeSourceCode) {
    appendFlag(sb, "source-code", includeSourceCode);
}

void appendIgnoreBrokenLink(StringBuilder sb, Boolean ignoreBrokenLink) {
    appendFlag(sb, "ignore-broken-link", ignoreBrokenLink);
}

void appendIgnoreMissingDoc(StringBuilder sb, Boolean ignoreMissingDoc) {
    appendFlag(sb, "ignore-missing-doc", ignoreMissingDoc);
}

void appendRun(StringBuilder sb, String? functionNameToRun) {
    appendParameter(sb, "run", functionNameToRun);
}

void appendDebug(StringBuilder sb, String? debug) {
    appendParameter(sb, "debug", debug);
}

void appendPathToNodeJs(StringBuilder sb, String? pathToNodeJs) {
    appendParameter(sb, "node-exe", pathToNodeJs);
}
     
void appendArguments(StringBuilder sb, {String*} arguments) {
    if (!arguments.empty) {
        sb.append(" ");
        sb.append(" ".join(arguments));
    }
}

void appendFlag(StringBuilder sb, String flag, Boolean appendFlag = true) {
    if (appendFlag) {
        sb.append(" --");
        sb.append(flag);
    }
}

void appendParameter<Value>(StringBuilder sb, String name, Value? val) {
    if (exists val, !val.string.empty) {
        sb.append(" --");
        sb.append(name);
        sb.append("=");
        sb.append(val.string);
    }
}

void appendList<Value>(StringBuilder sb, String name, {Value*} items) given Value satisfies Object {
    if (!items.empty) {
        sb.append(" --");
        sb.append(name);
        sb.append("=");
        sb.append(",".join({for (item in items) item.string}));
    }
}
