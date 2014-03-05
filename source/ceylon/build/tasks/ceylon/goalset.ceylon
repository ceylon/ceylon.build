import ceylon.build.task { goal, noop, NoOp, GoalException }

shared interface Backend of jvm | js {}
shared object jvm satisfies Backend {}
shared object js satisfies Backend {}
shared Set<Backend> allBackends(String moduleName) => HashSet { jvm, js };

shared class SourceSet(
    sources = [],
    resources = []
) {
    shared [String*] sources;
    shared [String*] resources;
}

shared class SourceSets(
    main = SourceSet(),
    test = SourceSet(["test-source"], ["test-resource"])
) {
    shared SourceSet main;
    shared SourceSet test;
}

Path home {
    if (exists home = process.propertyValue("user.home")) {
        return parsePath(home);
    }
    throw GoalException("Undefined system property 'user.home'");
}
Path defaultLocalRepository = home.childPath(".ceylon").childPath("repo");

shared class Output(main = null, test = "test-modules") {
    shared String? main;
    shared String? test;
}

shared class Repositories(
    output = Output(),
    dependencies = [],
    system = null,
    cache = null,
    local = defaultLocalRepository
) {
    shared Output output;
    shared [String*] dependencies;
    shared String? system;
    shared String? cache;
    shared Path local;
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
}

shared String name(Module m) => m.name;
shared String version(Module m) => moduleVersion(m.name, m.version);

[String*] testRepositories(CeylonModel model) {
    return concatenate(
        [model.repositories.output.main, model.repositories.output.test].coalesced,
        model.repositories.dependencies
    );
}

shared class Modules(modules) {
    shared [Module*] modules;
    
    shared default {String*} names => modules.map(name);
    
    shared default {Module*} backend(Backend backend)
        => modules.filter((Module m) => m.backends.contains(backend));
}

shared class CeylonModel(
    sourceSets = SourceSets(),
    repositories = Repositories(),
    backends = allBackends,
    main = discoverModules(sourceSets.main, backends),
    test = discoverModules(sourceSets.test, backends),
    encoding = null,
    ceylon = null
) {
    
    shared SourceSets sourceSets;
    
    shared Repositories repositories;
    
    Set<Backend>(String) backends;
    
    shared Modules main;
    
    shared Modules test;
    
    shared String? encoding;
    
    shared String? ceylon;
}

shared interface CeylonBasePlugin {
    
    shared formal CeylonModel model;
    
    goal
    shared default void clean() {
        // TODO factorize default "modules"/"test-modules" logic
        delete(parsePath(model.repositories.output.main else "modules"));
        delete(parsePath(model.repositories.output.test else "test-modules"));
    }
    
    goal
    shared default void doc() {
        package.document {
            modules = model.main.names;
            encoding = model.encoding;
            repositories = model.repositories.dependencies;
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            ceylon = model.ceylon;
        };
    }
    
    goal
    shared default void publish() {
        for (mod in model.main.modules) {
            // TODO factorize default "modules" logic
            value output = parsePath(model.repositories.output.main else "modules");
            value modulePath = mod.name.replace(".", "/");
            copyFiles {
                source = output.childPath(modulePath);
                destination = model.repositories.local.childPath(modulePath);
                overwrite = true;
            };
        }
    }
}

shared interface CeylonPlugin satisfies CeylonJvmPlugin & CeylonJsPlugin {}

object ceylon satisfies CeylonJvmPlugin & CeylonJsPlugin {
    model = CeylonModel();
}

shared interface CeylonJvmPlugin satisfies CeylonBasePlugin {
    
    goal
    shared default void compile() {
        package.compile {
            modules = model.main.backend(jvm).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.main.sources;
            resourceDirectories = model.sourceSets.main.resources;
            outputRepository = model.repositories.output.main;
            repositories = model.repositories.dependencies;
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            ceylon = model.ceylon;
        };
    }
    
    goal {
        name = "compile-tests";
    }
    shared default void compileTests() {
        package.compile {
            modules = model.test.backend(jvm).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.test.sources;
            resourceDirectories = model.sourceSets.test.resources;
            outputRepository = model.repositories.output.test;
            repositories = model.repositories.dependencies;
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            ceylon = model.ceylon;
        };
    }
    
    goal {
        name = "run-tests";
    }
    shared default void runTests() {
        package.test {
            modules = model.test.backend(jvm).map(version);
            repositories = testRepositories(model);
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            ceylon = model.ceylon else ceylonExecutable;
        };
    }
    
    goal {
        dependencies = [`function compile`, `function compileTests`, `function runTests`];
    }
    shared default NoOp test => noop;
}

shared interface CeylonJsPlugin satisfies CeylonBasePlugin {
    
    goal {
        name = "compile-js";
    }
    shared default void compileJs() {
        package.compileJs {
            modules = model.main.backend(js).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.main.sources;
            repositories = model.repositories.dependencies;
            outputRepository = model.repositories.output.main;
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            ceylon = model.ceylon;
        };
    }
    
    goal {
        name = "compile-js-tests";
    }
    shared default void compileJsTests() {
        package.compileJs {
            modules = model.test.backend(js).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.test.sources;
            outputRepository = model.repositories.output.test;
            repositories = testRepositories(model);
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            ceylon = model.ceylon;
        };
    }
    
    goal {
        name = "run-js-tests";
    }
    shared default void runJsTests() {
        for (mod in model.test.backend(jvm)) {
            package.runJsModule {
                moduleName = mod.name;
                version = mod.version;
                ceylon = model.ceylon else ceylonExecutable;
            };
        }
    }
    
    goal {
        name = "test-js";
        dependencies = [`function compileJs`, `function compileJsTests`, `function runJsTests`];
    }
    shared default NoOp testJs => noop;
}

shared Modules discoverModules(SourceSet sourceSet, Set<Backend>(String) backends) {
    value modules = SequenceBuilder<Module>();
    for (source in sourceSet.sources) {
        value path = parsePath(source);
        if (is Directory resource = path.resource) {
            modules.appendAll(checkDirectory(resource, backends));
        } else {
            throw GoalException("source folder ``path.absolutePath`` is not a directory");
        }
    }
    return Modules(modules.sequence);
}

[Module*] checkDirectory(Directory directory, Set<Backend>(String) backends) {
    value modules = SequenceBuilder<Module>();
    value files = directory.files("module.ceylon");
    if (nonempty seq = files.sequence) {
        modules.append(parseModuleDescriptor(seq.first, backends));
    } else {
        for (childDirectory in directory.childDirectories()) {
            modules.appendAll(checkDirectory(childDirectory, backends));
        }
    }
    return modules.sequence;
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
