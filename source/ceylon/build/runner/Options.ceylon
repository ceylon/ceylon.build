import ceylon.collection {
    ArrayList,
    HashSet,
    HashMap
}

Options commandLineOptions(String[] args) {
    value arguments = parseProcessArguments(args);
    return Options(arguments);
}

Arguments parseProcessArguments(String[] args) {
    value arguments = Arguments();
    for (arg in args) {
        if (arg.startsWith("--")) {
            String option = arg[2...];
            if (exists index = option.firstOccurrence('=')) {
                arguments.addOption(option[... index-1], option[index+1 ...]);
            } else {
                arguments.setFlag(option);
            }
        } else if (exists index = arg.firstOccurrence('/')) {
            arguments.buildModuleName = arg[... index-1];
            arguments.buildModuleVersion = arg[index+1 ...];
        } else {
            arguments.addGoal(arg);
        }
    }
    return arguments;
}

class Arguments() {
    value options = HashMap<String,ArrayList<String>>();
    value flags = HashSet<String>();
    value _goals = ArrayList<String>();
    
    shared variable String? buildModuleName = null;
    shared variable String? buildModuleVersion = null;
    
    shared void addOption(String name, String val) {
        if (exists values = options[name]) {
            values.add(val);
        } else {
            options.put(name, ArrayList<String> { elements = { val }; });
        }
    }
    shared String? firstOption(String name) => options[name]?.first;
    shared {String*} allOptions(String name) => options[name] else [];
    
    shared void setFlag(String flag) => flags.add(flag);
    shared Boolean hasFlag(String flag) => flags.contains(flag);
    
    shared void addGoal(String goal) => _goals.add(goal);
    shared [String*] goals => _goals.sequence();
    
    shared {String*} listOptions => concatenate(options.keys, flags);
}

suppressWarnings("expressionTypeNothing")
class Options(Arguments arguments) {
    
    ConfigResolver resolver = ConfigResolver(arguments);
    
    variable String? buildModuleName = arguments.buildModuleName;
    variable String? buildModuleVersion = arguments.buildModuleVersion;
    if (!(buildModuleName exists)) {
        String? defaultModule = resolver.option(null, "build.module", "build/1");
        assert(exists defaultModule);
        if (exists index = defaultModule.firstOccurrence('/')) {
            buildModuleName = defaultModule[... index-1];
            buildModuleVersion = defaultModule[index+1 ...];
        } else {
            buildModuleName = defaultModule;
            buildModuleVersion = "1";
        }
    }
    assert(exists finalModuleName = buildModuleName, exists finalModuleVersion = buildModuleVersion);
    shared String moduleName = finalModuleName;
    shared String moduleVersion = finalModuleVersion;
    
    shared CompilationOptions compilation = CompilationOptions(resolver, moduleName);
    shared RuntimeOptions runtime = RuntimeOptions(resolver);
    
    shared {String*} goals => arguments.goals;
    for (option in arguments.listOptions) {
        if (!compilation.knows(option) && !runtime.knows(option)) {
            process.writeErrorLine("Unknown option '``option``'");
            process.exit(exitCodes.unknownOption);
        }
    }
}

interface OptionsHandler {
    "Return `true` if the given option is known by current option handler."
    shared formal Boolean knows(String option);
}

class CompilationOptions(ConfigResolver resolver, String moduleName) satisfies OptionsHandler {
    
    ConfigResolverJava x = ConfigResolverJava(null);
    String? cacheRepository = resolver.option("cacherep", "builder.cache.repo");
    String? currentWorkingDirectory = resolver.option("cwd", null);
    {String*} systemProperties = resolver.options("define", null);
    String? encoding = resolver.option("encoding", "builder.encoding", resolver.option(null, "defaults.encoding"));
    {String*} javacOptions = resolver.options("javac", "builder.javacoption");
    String? mavenOverrides = resolver.option("maven-overrides", "builder.mavenoverrides");
    Boolean noDefaultRepositories = resolver.flag("no-default-repositories", "builder.nodefaultrepositories");
    Boolean offline = resolver.flag("offline", "builder.offline");
    {String*} repositories = resolver.options("rep", "builder.user.repo");
    {String*} resourceDirectories = resolver.options("resource", "builder.resource");
    value inputSources = concatenate(resolver.options("source", null), resolver.options("src", null));
    {String*} sourceDirectories = if (!inputSources.empty) then inputSources else resolver.options(null, "builder.source", { "build-source" } );
    {String*} supressWarnings = resolver.options("suppress-warning", "builder.suppresswarning");
    String? systemRepository = resolver.option("sysrep", "builder.system.repo");
    String? timeout = resolver.option("timeout", "builder.timeout", resolver.option(null, "defaults.timeout"));
    {String*} verbose = resolver.options("verbose", "builder.verbose");
    Boolean allVerbose = resolver.flag("verbose", null);
    
    value knownOptions = HashSet {
        elements = { "cacherep", "cwd", "define", "encoding", "javac", "maven-overrides", "no-default-repositories",
            "offline", "rep", "resource", "source", "src", "suppress-warning", "sysrep", "timeout", "verbose" };
    };
    
    shared actual Boolean knows(String option) {
        return knownOptions.contains(option);
    }
    
    shared {String*} buildCompilerOptions() {
        ArrayList<String> result = ArrayList<String>();
        void addFlag(String optionString, Boolean variable) {
            if (variable) {
                result.add("``optionString``");
            }
        }
        void addValue(String optionString, String? variable) {
            if (exists variable) {
                result.add("``optionString``=``variable``");
            }
        }
        void addList(String optionString, {String*} variable) {
            for (entry in variable) {
                result.add("``optionString``=``entry``");
            }
        }
        result.add("compile");
        result.add("--out=modules");
        addValue("--cacherep", cacheRepository);
        addValue("--cwd", currentWorkingDirectory);
        addList("--define", systemProperties);
        addValue("--encoding", encoding);
        addList("--javac", javacOptions);
        addValue("--maven-overrides", mavenOverrides);
        addFlag("--no-default-repositories", noDefaultRepositories);
        addFlag("--offline", offline);
        addList("--rep", repositories);
        addList("--resource", resourceDirectories);
        addList("--source", sourceDirectories);
        addList("--suppress-warning", supressWarnings);
        addValue("--systemRepository", systemRepository);
        addValue("--timeout", timeout);
        addList("--verbose", verbose);
        addFlag("--verbose", allVerbose);
        result.add(moduleName);
        return result;
    }
}

class RuntimeOptions(ConfigResolver resolver) satisfies OptionsHandler {
    shared Boolean consoleMode = resolver.flag("console", null);
    
    shared actual Boolean knows(String option) => option == "console";
}