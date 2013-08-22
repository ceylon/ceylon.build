void appendEncoding(StringBuilder sb, String? encoding) {
    appendParameter(sb, "encoding", encoding);
}

void appendJavacOptions(StringBuilder sb, String? javacOptions) {
    appendParameter(sb, "javac", javacOptions);
}

void appendOutputModuleRepository(StringBuilder sb, String? outputModuleRepository) {
    appendParameter(sb, "out", outputModuleRepository);
}

void appendDependenciesRepository(StringBuilder sb, String? dependenciesRepository) {
    appendParameter(sb, "rep", dependenciesRepository);
}

void appendSourceDirectories(StringBuilder sb, {String*} sourceDirectories) {
    for (sourceDirectory in sourceDirectories) {
        appendParameter(sb, "src", sourceDirectory);
    }
}

void appendSystemRepository(StringBuilder sb, String? systemRepository) {
    appendParameter(sb, "sysrep", systemRepository);
}

void appendUser(StringBuilder sb, String? user) {
    appendParameter(sb, "user", user);
}

void appendPassword(StringBuilder sb, String? password) {
    appendParameter(sb, "pass", password);
}

void appendDisableModuleRepository(StringBuilder sb, Boolean disableModuleRepository) {
    appendFlag(sb, "d", disableModuleRepository);
}

void appendOfflineMode(StringBuilder sb, Boolean offline) {
    appendFlag(sb, "offline", offline);
}

void appendVerboseModes(StringBuilder sb, {<CompileVerboseMode|RunVerboseMode>*} verboseModes) {
    appendList(sb, "verbose", verboseModes);
}

void appendCompact(StringBuilder sb, Boolean compact) {
    appendFlag(sb, "compact", compact);
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

void appendRun(StringBuilder sb, String? functionNameToRun) {
    appendParameter(sb, "run", functionNameToRun);
}

void appendDebug(StringBuilder sb, String? debug) {
    appendParameter(sb, "debug", debug);
}
void appendPathToNodeJs(StringBuilder sb, String? pathToNodeJs) {
    appendParameter(sb, "node-exe", pathToNodeJs);
}

        
void appendArguments(StringBuilder sb, String[] arguments) {
    if (nonempty arguments) {
        sb.append(" ");
        sb.append(" ".join(arguments));
    }
}

void appendFlag(StringBuilder sb, String flag, Boolean appendFlag) {
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