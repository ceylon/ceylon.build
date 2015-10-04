import ceylon.collection {
	ArrayList,
	HashSet,
	HashMap
}

Options commandLineOptions(String[] args) {
	value arguments = parseProcessArguments(args);
	return Options(arguments);
}

Arguments parseProcessArguments(String[] arguments) {
	value args = Arguments();
	for (argument in arguments) {
		if (argument.startsWith("--")) {
			String option = argument[2...];
			if (exists index = option.firstOccurrence('=')) {
				args.addOption(option[... index-1], option[index+1 ...]);
			} else {
				args.setFlag(option);
			}
		} else if (exists index = argument.firstOccurrence('/')) {
			args.buildModuleName = argument[... index-1];
			args.buildModuleVersion = argument[index+1 ...];
		} else {
			args.addGoal(argument);
		}
	}
	return args;
}

class Arguments() {
	value options = HashMap<String,ArrayList<String>>();
	value flags = HashSet<String>();
	value _goals = ArrayList<String>();
	
	shared variable String buildModuleName = "build";
	shared variable String buildModuleVersion = "1";
	
	shared void addOption(String name, String val) {
		if (exists values = options[name]) {
			values.add(val);
		} else {
			options.put(name, ArrayList<String> { elements = { val }; });
		}
	}
	shared String? firstOption(String name) => options[name]?.first;
	shared {String*} option(String name) => options[name] else [];
	
	shared void setFlag(String flag) => flags.add(flag);
	shared Boolean hasFlag(String flag) => flags.contains(flag);
	
	shared void addGoal(String goal) => _goals.add(goal);
	shared [String*] goals => _goals.sequence();
	
	shared {String*} listOptions => concatenate(options.keys, flags);
}

class Options(Arguments arguments) {
	
	shared String moduleName = arguments.buildModuleName;
	shared String moduleVersion = arguments.buildModuleVersion;
	
	shared CompilationOptions compilation = CompilationOptions(arguments);
	shared RuntimeOptions runtime = RuntimeOptions(arguments);
	
	shared {String*} goals => arguments.goals;
	for (option in arguments.listOptions) {
		if (!compilation.knows(option) && !runtime.knows(option)) {
			process.writeErrorLine("Unknown option '``option``'");
			process.exit(1);
		}
	}
}

interface OptionsHandler {
	"Return `true` if the given option is know by current option handler."
	shared formal Boolean knows(String option);
}

class CompilationOptions(Arguments args) satisfies OptionsHandler {
	
	String moduleName = args.buildModuleName;
	
	String? cacheRepository = args.firstOption("cacherep");
	String? currentWorkingDirectory = args.firstOption("cwd");
	{String*} systemProperties = args.option("define");
	String? encoding = args.firstOption("encoding");
	{String*} javacOptions = args.option("javac");
	String? mavenOverrides = args.firstOption("maven-overrides");
	Boolean noDefaultRepositories = args.hasFlag("no-default-repositories");
	Boolean offline = args.hasFlag("offline");
	{String*} repositories = args.option("rep");
	{String*} resourceDirectories = args.option("resource");
	value inputSources = concatenate(args.option("source"), args.option("src"));
	{String*} sourceDirectories = if (!inputSources.empty) then inputSources else ["build-source"];
	{String*} supressWarnings = args.option("suppress-warning");
	String? systemRepository = args.firstOption("sysrep");
	String? timeout = args.firstOption("timeout");
	{String*} verbose = args.option("verbose");
	Boolean allVerbose = args.hasFlag("verbose");
	
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

class RuntimeOptions(Arguments arguments) satisfies OptionsHandler {
	shared Boolean consoleMode = arguments.hasFlag("console");
	
	shared actual Boolean knows(String option) => option == "console";
}