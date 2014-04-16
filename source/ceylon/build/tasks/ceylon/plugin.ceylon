import ceylon.build.task { goal, dependsOn, attachTo, noop, NoOp }
import ceylon.file { parsePath }
import ceylon.build.tasks.file { copyFiles, delete }
import ceylon.build.tasks.ceylon { ceylonExecutable }

shared interface CeylonBasePlugin {
    
    shared formal CeylonModel model;
    
    function mainOutputFolderOrDefault() => model.repositories.output.main else "modules";
    
    function testOutputFolderOrDefault() => model.repositories.output.test else "test-modules";
    
    goal
    shared default void clean() {
        for (path in [mainOutputFolderOrDefault(), testOutputFolderOrDefault()]) {
            delete(parsePath(path));
        }
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
            documentationDirectory = model.options.doc.documentationDirectory;
            link = model.options.doc.link;
            includeNonShared = model.options.doc.includeNonShared;
            includeSourceCode = model.options.doc.includeSourceCode;
            ignoreBrokenLink = model.options.doc.ignoreBrokenLink;
            ignoreMissingDoc = model.options.doc.ignoreMissingDoc;
            ignoreMissingThrows = model.options.doc.ignoreMissingThrows;
            header = model.options.doc.header;
            footer = model.options.doc.footer;
            systemProperties = model.options.doc.systemProperties;
            verboseModes = model.options.doc.verboseModes;
        };
    }
    
    goal("compile")
    shared default NoOp compile => noop;
    
    goal("compile-tests")
    dependsOn(`value compile`)
    shared default NoOp compileTests => noop;
    
    goal("test")
    dependsOn(`value compileTests`)
    shared default NoOp test => noop;
    
    goal
    dependsOn(`value compile`)
    shared default void publish() {
        for (mod in model.main.modules) {
            value output = parsePath(mainOutputFolderOrDefault());
            value modulePath = mod.name.replace(".", "/");
            copyFiles {
                source = output.childPath(modulePath);
                destination = model.repositories.local.childPath(modulePath);
                overwrite = true;
            };
        }
    }
    
    goal
    dependsOn(`value test`, `function publish`)
    shared default NoOp build => noop;
}

shared interface CeylonJvmPlugin satisfies CeylonBasePlugin {
    
    goal("compile-jvm")
    attachTo(`value compile`)
    shared default void compileJvm() {
        package.compile {
            modules = model.main.backend(jvm).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.main.sources;
            resourceDirectories = model.sourceSets.main.resources;
            outputRepository = model.repositories.output.main;
            repositories = model.repositories.dependencies;
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            offline = model.repositories.offline;
            noDefaultRepositories = model.repositories.noDefaultRepositories;
            javacOptions = model.options.compile.javacOptions;
            systemProperties = model.options.compile.systemProperties;
            verboseModes = model.options.compile.verboseModes;
            ceylon = model.ceylon;
        };
    }
    
    goal("compile-jvm-tests")
    dependsOn(`function compileJvm`)
    attachTo(`value compileTests`)
    shared default void compileJvmTests() {
        package.compile {
            modules = model.test.backend(jvm).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.test.sources;
            resourceDirectories = model.sourceSets.test.resources;
            outputRepository = model.repositories.output.test;
            repositories = testRepositories(model);
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            offline = model.repositories.offline;
            noDefaultRepositories = model.repositories.noDefaultRepositories;
            javacOptions = model.options.compileTests.javacOptions;
            systemProperties = model.options.compileTests.systemProperties;
            verboseModes = model.options.compileTests.verboseModes;
            ceylon = model.ceylon;
        };
    }
    
    goal("test-jvm")
    dependsOn(`function compileJvmTests`)
    attachTo(`value test`)
    shared default void testJvm() {
        package.test {
            modules = model.test.backend(jvm).map(version);
            repositories = testRepositories(model);
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            offline = model.repositories.offline;
            noDefaultRepositories = model.repositories.noDefaultRepositories;
            tests = model.options.test.tests;
            compileOnRun = model.options.test.compileOnRun;
            systemProperties = model.options.test.systemProperties;
            verboseModes = model.options.test.verboseModes;
            ceylon = model.ceylon else ceylonExecutable;
        };
    }
}

shared interface CeylonJsPlugin satisfies CeylonBasePlugin {
    
    goal("compile-js")
    attachTo(`value compile`)
    shared default void compileJs() {
        package.compileJs {
            modules = model.main.backend(js).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.main.sources;
            repositories = testRepositories(model);
            outputRepository = model.repositories.output.main;
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            files = model.options.compileJs.files;
            compact = model.options.compileJs.compact;
            lexicalScopeStyle = model.options.compileJs.lexicalScopeStyle;
            noComments = model.options.compileJs.noComments;
            noIndent = model.options.compileJs.noIndent;
            noModule = model.options.compileJs.noModule;
            optimize = model.options.compileJs.optimize;
            profile = model.options.compileJs.profile;
            skipSourceArchive = model.options.compileJs.skipSourceArchive;
            systemProperties = model.options.compileJs.systemProperties;
            verboseModes = model.options.compileJs.verboseModes;
            ceylon = model.ceylon;
        };
    }
    
    goal("compile-js-tests")
    dependsOn(`function compileJs`)
    attachTo(`value compileTests`)
    shared default void compileJsTests() {
        package.compileJs {
            modules = model.test.backend(js).map(name);
            encoding = model.encoding;
            sourceDirectories = model.sourceSets.test.sources;
            outputRepository = model.repositories.output.test;
            repositories = testRepositories(model);
            systemRepository = model.repositories.system;
            cacheRepository = model.repositories.cache;
            files = model.options.compileJsTests.files;
            compact = model.options.compileJsTests.compact;
            lexicalScopeStyle = model.options.compileJsTests.lexicalScopeStyle;
            noComments = model.options.compileJsTests.noComments;
            noIndent = model.options.compileJsTests.noIndent;
            noModule = model.options.compileJsTests.noModule;
            optimize = model.options.compileJsTests.optimize;
            profile = model.options.compileJsTests.profile;
            skipSourceArchive = model.options.compileJsTests.skipSourceArchive;
            systemProperties = model.options.compileJsTests.systemProperties;
            verboseModes = model.options.compileJsTests.verboseModes;
            ceylon = model.ceylon;
        };
    }
    
    goal("test-js")
    dependsOn(`function compileJsTests`)
    attachTo(`value test`)
    shared default void testJs() {
        for (mod in model.test.backend(jvm)) {
            package.runJsModule {
                moduleName = mod.name;
                version = mod.version;
                ceylon = model.ceylon else ceylonExecutable;
            };
        }
    }
}

shared interface CeylonPlugin satisfies CeylonJvmPlugin & CeylonJsPlugin {
    
}
