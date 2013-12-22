String? appendCurrentWorkingDirectory(String? currentWorkingDirectory) =>
    parameter("cwd", currentWorkingDirectory);

String? appendEncoding(String? encoding) =>
    parameter("encoding", encoding);


String? appendJavacOptions(String? javacOptions) =>
    parameter("javac", javacOptions);

String? appendOutputRepository(String? outputRepository) =>
    parameter("out", outputRepository);

{String*} appendRepositories({String*} repositories) =>
    { for (repository in repositories) parameter("rep", repository) }.coalesced;

{String*} appendSourceDirectories({String*} sourceDirectories) =>
    { for (sourceDirectory in sourceDirectories) parameter("source", sourceDirectory) }.coalesced;

String? appendDocumentationDirectory(String? documentationDirectory) =>
    parameter("doc", documentationDirectory);

{String*} appendResourceDirectories({String*} resourceDirectories) =>
    { for (resourceDirectory in resourceDirectories) parameter("resource", resourceDirectory) }.coalesced;

String? appendSystemRepository(String? systemRepository) =>
    parameter("sysrep", systemRepository);

String? appendCacheRepository(String? cacheRepository) =>
    parameter("cacherep", cacheRepository);

String? appendUser(String? user) =>
    parameter("user", user);

String? appendPassword(String? password) =>
    parameter("pass", password);

String? appendNoDefaultRepositories(Boolean noDefaultRepositories) =>
    flag("no-default-repositories", noDefaultRepositories);

String? appendOfflineMode(Boolean offline) =>
    flag("offline", offline);

{String*} appendSystemProperties({<String->String>*} systemProperties) => {
    for (systemProperty in systemProperties)
        parameter("define", "``systemProperty.key``=``systemProperty.item``")
}.coalesced;

String? appendVerboseModes({VerboseMode*}|AllVerboseModes verboseModes) {
    if (is {VerboseMode*} verboseModes) {
        return list("verbose", verboseModes);
    } else {
        return flag("verbose");
    }
}

{String*} appendCompilationUnits({String*} modules, {String*} files = []) => concatenate(modules, files);

String? appendModule(String name, String? version) => moduleVersion(name, version);

String? appendCompact(Boolean compact) =>
    flag("compact", compact);

String? appendLexicalScopeStyle(Boolean lexicalScopeStyle) =>
    flag("lexical-scope-style", lexicalScopeStyle);

String? appendNoComments(Boolean noComments) =>
    flag("no-comments", noComments);

String? appendNoIndent(Boolean noIndent) =>
    flag("no-indent", noIndent);

String? appendNoModule(Boolean noModule) =>
    flag("no-module", noModule);

String? appendOptimize(Boolean optimize) =>
    flag("optimize", optimize);

String? appendProfile(Boolean profile) =>
    flag("profile", profile);

String? appendSkipSourceArchive(Boolean skipSourceArchive) =>
    flag("skip-src-archive", skipSourceArchive);

String? appendLink(String? link) =>
    parameter("link", link);

String? appendIncludeNonShared(Boolean includeNonShared) =>
    flag("non-shared", includeNonShared);

String? appendIncludeSourceCode(Boolean includeSourceCode) =>
    flag("source-code", includeSourceCode);

String? appendIgnoreBrokenLink(Boolean ignoreBrokenLink) =>
    flag("ignore-broken-link", ignoreBrokenLink);

String? appendIgnoreMissingDoc(Boolean ignoreMissingDoc) =>
    flag("ignore-missing-doc", ignoreMissingDoc);

String? appendIgnoreMissingThrows(Boolean ignoreMissingThrows) =>
    flag("ignore-missing-throws", ignoreMissingThrows);

String? appendHeader(String? header) =>
    parameter("header", header);

String? appendFooter(String? footer) =>
    parameter("footer", footer);

String? appendRun(String? functionNameToRun) =>
    parameter("run", functionNameToRun);

String? appendCompileOnRun(CompileOnRun? compileOnRun) =>
    parameter<CompileOnRun>("compile", compileOnRun);

String? appendTests({String*} tests) =>
    list("test", tests.map((String test) => "'``test``'"));

String? appendDebug(String? debug) =>
    parameter("debug", debug);

String? appendPathToNodeJs(String? pathToNodeJs) =>
    parameter("node-exe", pathToNodeJs);

{String*} appendArguments({String*} arguments) => arguments;

{String*} appendModuleArguments({String*} arguments) {
    if (!arguments.empty) {
        return concatenate({"--"}, arguments);
    }
    return {};
}

String? flag(String flag, Boolean appendFlag = true) {
    if (appendFlag) {
        return "--``flag``";
    }
    return null;
}

String? parameter<Value>(String name, Value? val) {
    if (exists val, !val.string.empty) {
        return "--``name``=``val.string``";
    }
    return null;
}

String? list<Value>(String name, {Value*} items) given Value satisfies Object {
    if (!items.empty) {
        return "--``name``=``",".join({ for (item in items) item.string })``";
    }
    return null;
}
