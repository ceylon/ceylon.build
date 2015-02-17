import ceylon.build.task {
    GoalException
}
import ceylon.collection {
    HashSet,
    ArrayList
}
import ceylon.file {
    parsePath,
    Directory,
    File,
    Path,
    ExistingResource
}
import ceylon.interop.java {
    javaString
}

import java.util.regex {
    Pattern {
        compilePattern=compile
    }
}

shared class CeylonModel(
    sourceSets = SourceSets(),
    repositories = Repositories(),
    main = discoverModules(sourceSets.main),
    test = discoverModules(sourceSets.test),
    options = Options(),
    encoding = null,
    systemProperties = {},
    ceylon = null
) {
    
    shared SourceSets sourceSets;
    
    shared Repositories repositories;
    
    shared Modules main;
    
    shared Modules test;
    
    shared Options options;
    
    shared String? encoding;
    
    shared {<String->String>*} systemProperties;
    
    shared String? ceylon;
    
    string => "CeylonModel(sourceSets=``sourceSets``, repositories=``repositories``, main=``main``, " +
            "test=``test``, encoding=``encoding else "<null>"``, ceylon=``ceylon else "<null>"``)";
}

shared class SourceSets(
    main = SourceSet(),
    test = SourceSet(["test-source"], ["test-resource"])
) {
    shared SourceSet main;
    
    shared SourceSet test;
    
    string => "SourceSets(main=``main``, test=``test``)";
}

shared class SourceSet(
    sources = [],
    resources = []
) {
    shared [String*] sources;
    
    shared [String*] resources;
    
    string => "SourceSet(sources=``sources``, resources=``resources``)";
}
shared class Repositories(
    output = Output(),
    dependencies = [],
    system = null,
    cache = null,
    offline = false,
    noDefaultRepositories = false,
    local = defaultLocalRepository
) {
    shared Output output;
    shared [String*] dependencies;
    shared String? system;
    shared String? cache;
    
    "Enables offline mode that will prevent the module loader from connecting to remote repositories."
    shared Boolean offline;
        
    "Indicates that the default repositories should not be used"
    shared Boolean noDefaultRepositories;
    
    shared Path local;
    
    string => "Repositories(output=``output``, dependencies=``dependencies``, system=``system else "<null>"``, " +
        "cache=``cache else "<null>"``, local=``local``)";
}

Path home {
    if (exists home = process.propertyValue("user.home")) {
        return parsePath(home);
    }
    throw GoalException("Undefined system property 'user.home'");
}
shared Path defaultLocalRepository = home.childPath(".ceylon").childPath("repo");

shared class Output(main = null, test = "test-modules") {
    shared String? main;
    shared String? test;
    
    string => "Output(main=``main else "<null>"``, test=``test else "<null>"``)";
}

shared class Modules(modules) satisfies {Module*} {
    
    shared [Module*] modules;
    
    shared default {String*} names => modules.map(name);
    
    shared default Module named(String name) {
        if (exists m = modules.find((Module m) => m.name.equals(name))) {
            return m;
        }
        throw GoalException("Module ``name`` not found. Found modules: ``modules``");
    }
    
    shared default {Module*} backend(Backend backend)
            => modules.filter((Module m) => m.backends.contains(backend));

    shared default actual Iterator<Module> iterator() => modules.iterator();
    
    string => modules.string;
}

shared class Module(
    name,
    version = null,
    backends = HashSet {
        elements = {jvm, js};
    }
) {
    shared String name;
    shared String? version;
    shared Set<Backend> backends;
    
    string => "Module ``name``/``version else "default"`` for ``backends``";
}

shared interface Backend of jvm | js {}
shared object jvm satisfies Backend { string => "jvm"; }
shared object js satisfies Backend { string => "js"; }


shared class Options(
    compile = CompileOptions(),
    compileTests = compile,
    compileJs = CompileJsOptions(),
    compileJsTests = compileJs,
    doc = DocOptions(),
    test = TestOptions(),
    testJs = TestJsOptions()
) {
    shared CompileOptions compile;
    shared CompileOptions compileTests;
    shared CompileJsOptions compileJs;
    shared CompileJsOptions compileJsTests;
    shared DocOptions doc;
    shared TestOptions test;
    shared TestJsOptions testJs;
}

shared class CompileOptions(
    javacOptions = null,
    systemProperties = [],
    verboseModes = []) {
        
    "Passes an option to the underlying java compiler
     (corresponding command line parameter: `--javac=<option>`)"
    shared String? javacOptions;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`; `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
        
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared {CompileVerboseMode*}|AllVerboseModes verboseModes;
}

shared class CompileJsOptions(
    files = [],
    compact = false,
    lexicalScopeStyle = false,
    noComments = false,
    noIndent = false,
    noModule = false,
    optimize = false,
    profile = false,
    skipSourceArchive = false,
    systemProperties = [],
    verboseModes = []) {
    
    "name of files to compile"
    shared {String*} files;
    
    "Equivalent to '--no-indent' '--no-comments'
     (corresponding command line parameter: `--compact`)"
    shared Boolean compact;
    
    "Create lexical scope-style JS code
     (corresponding command line parameter: `--lexical-scope-style`)"
    shared Boolean lexicalScopeStyle;
    
    "Do NOT generate any comments
     (corresponding command line parameter: `--no-comments`)"
    shared Boolean noComments;
    
    "Do NOT indent code
     (corresponding command line parameter: `--no-indent`)"
    shared Boolean noIndent;
    
    "Do NOT wrap generated code as CommonJS module
     (corresponding command line parameter: `--no-module`)"
    shared Boolean noModule;
    
    "Create prototype-style JS code
     (corresponding command line parameter: `--optimize`)"
    shared Boolean optimize;
    
    "Time the compilation phases (results are printed to standard error)
     (corresponding command line parameter: `--profile`)"
    shared Boolean profile;
    
    "Do NOT generate .src archive - useful when doing joint compilation
     (corresponding command line parameter: `--skip-src-archive`)"
    shared Boolean skipSourceArchive;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    
    "Indicates that the default repositories should not be used
     (corresponding command line parameter: `--no-default-repositories`)"
    shared {CompileJsVerboseMode*}|AllVerboseModes verboseModes;
}


shared class DocOptions(
    documentationDirectory = null,
    link = null,
    includeNonShared = false,
    includeSourceCode = false,
    ignoreBrokenLink = false,
    ignoreMissingDoc = false,
    ignoreMissingThrows = false,
    header = null,
    footer = null,
    systemProperties = [],
    verboseModes = []) {
    
    "A directory containing your module documentation
     (default: './doc')
     (corresponding command line parameter: `--doc=<dirs>`)"
    shared String? documentationDirectory;
    
    "The URL of a module repository containing documentation for external dependencies.
     
     Parameter url must be one of supported protocols (http://, https:// or file://).
     Parameter url can be prefixed with module name pattern, separated by a '=' character,
     determine for which external modules will be use.
     
     Examples:
     
     - --link https://modules.ceylon-lang.org/
     - --link ceylon.math=https://modules.ceylon-lang.org/
     
     (corresponding command line parameter: `--link=<url>`)"
    shared String? link;
    
    "Includes documentation for package-private declarations.
     (corresponding command line parameter: `--non-shared`)"
    shared Boolean includeNonShared;
    
    "Includes source code in the generated documentation.
     (corresponding command line parameter: `--source-code`)"
    shared Boolean includeSourceCode;
    
    "Do not print warnings about broken links.
     (corresponding command line parameter: `--ignore-broken-link`)"
    shared Boolean ignoreBrokenLink;
    
    "Do not print warnings about missing documentation.
     (corresponding command line parameter: `--ignore-missing-doc`)"
    shared Boolean ignoreMissingDoc;
    
    "Do not print warnings about missing throws annotation.
     (corresponding command line parameter: `--ignore-missing-throws`)"
    shared Boolean ignoreMissingThrows;
    
    "Sets the header text to be placed at the top of each page.
     (corresponding command line parameter: `--header=<header>`)"
    shared String? header;
    
    "Sets the footer text to be placed at the bottom of each page.
     (corresponding command line parameter: `--footer=<footer>`)"
    shared String? footer;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`; `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    shared {DocVerboseMode*}|AllVerboseModes verboseModes;
}

shared class TestOptions(
    tests = [],
    compileOnRun = null,
    systemProperties = [],
    verboseModes = []
) {
    
    "Specifies which tests will be run.
     (corresponding command line parameter: `--test=<test>`)"
    shared {String*} tests;
    
    "Determines if and how compilation should be handled.
     (corresponding command line parameter: `--compile[=<flags>]`)"
    shared CompileOnRun? compileOnRun;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`; `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    shared {RunTestsVerboseMode*}|AllVerboseModes verboseModes;
}

shared class TestJsOptions() {
}

shared String name(Module m) => m.name;
shared String version(Module m) => moduleVersion(m.name, m.version);

shared [String*] testRepositories(CeylonModel model) {
    return concatenate(
        [model.repositories.output.main else "modules", model.repositories.output.test].coalesced,
        model.repositories.dependencies
    );
}

[String*] defaultSourceDirectory(SourceSet sourceSet)
        => sourceSet.sources.empty then ["source"] else sourceSet.sources;

shared Modules discoverModules(SourceSet sourceSet, Set<Backend>(String) backends = allBackends) {
    value modules = ArrayList<Module>();
    value sources = defaultSourceDirectory(sourceSet);
    for (source in sources) {
        value path = parsePath(source);
        value resource = path.resource;
        if (is Directory resource) {
            modules.addAll(checkDirectory(resource, backends));
        } else if (is ExistingResource resource){
            throw GoalException("source folder ``path.absolutePath`` is not a directory");
        }
    }
    return Modules(modules.sequence());
}

[Module*] checkDirectory(Directory directory, Set<Backend>(String) backends) {
    value modules = ArrayList<Module>();
    value files = directory.files("module.ceylon");
    if (nonempty seq = files.sequence()) {
        modules.add(parseModuleDescriptor(seq.first, backends));
    } else {
        for (childDirectory in directory.childDirectories()) {
            modules.addAll(checkDirectory(childDirectory, backends));
        }
    }
    return modules.sequence();
}

String moduleRegex = "module\\s+([a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*)\\s+\"([^\"]+)\"\\s*(?:\\{.*)?$";
Pattern modulePattern = compilePattern(moduleRegex);

Module parseModuleDescriptor(File moduleDescriptor, Set<Backend>(String) backends) {
    value reader = moduleDescriptor.reader();
    while (exists line = reader.readLine()) {
        value matcher = modulePattern.matcher(javaString(line));
        if (matcher.matches()) {
            value name = matcher.group(1);
            value version = matcher.group(2);
            return Module {
                name = name;
                version = version;
                backends = backends(name); // TODO add a backends annotation and parse it
            };
        }
    }
    throw GoalException("Unable to parse module descriptor ``moduleDescriptor.path.absolutePath``");
}

shared Set<Backend> allBackends(String moduleName) => HashSet { jvm, js };
