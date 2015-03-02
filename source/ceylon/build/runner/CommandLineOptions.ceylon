import ceylon.collection {
    ArrayList
}

CommandLineOptions commandLineOptions() {
    value arguments = parseProcessArguments();
    return CommandLineOptions(arguments);
}

{CommandLineOption|String*} parseProcessArguments(String[] arguments = process.arguments) {
    value result = arguments.map<CommandLineOption|String>((String argument) {
        if (argument.startsWith("--")) {
            if (exists index = argument.firstIndexWhere('='.equals)) {
                return CommandLineOption(argument[... index-1], argument[index+1 ...]);
            } else {
                return CommandLineOption(argument, null);
            }
        } else {
            return argument;
        }
    });
    return result;
}

class CommandLineOption(key, val) {
    shared String key;
    shared String? val;
    
    shared actual String string {
        if (exists val) {
            return "``key``=``val``";
        } else {
            return "``key``";
        }
    }
    
}

"""
   Maps parsed options onto compiler options, goals, and goal options in the form
   `--compileroption1=value --compileroption2=value --compileroption3 module/version goal1 goal2 goal3 --goaloption1 --goaloption2=value`
   
   `buildModule` is set to module/version (if a module`/`version is given before the goals), otherwise the default is `build/1`.
   `goals` contain the called goals.
   `goalOptions` contain options for the goals (not used currently).
   
   The other options are the standard compiler options.
"""
class CommandLineOptions({CommandLineOption|String*} options) {
    // defaults
    String defaultModule = "build/1";
    String defaultSourceDirectory = "build-source";
    // internal option collection
    variable String? cacheRepository = null;
    variable String? currentWorkingDirectory = null;
    ArrayList<String> systemProperties = ArrayList<String>();
    variable String? encoding = null;
    ArrayList<String> javacOptions = ArrayList<String>();
    variable String? mavenOverrides = null;
    variable Boolean noDefaultRepositories = false;
    variable Boolean offline = false;
    ArrayList<String> repositories = ArrayList<String>();
    ArrayList<String> resourceDirectories = ArrayList<String>();
    ArrayList<String> sourceDirectories = ArrayList<String>();
    ArrayList<String> supressWarnings = ArrayList<String>();
    variable String? systemRepository = null;
    variable String? timeout = null;
    ArrayList<String> verbose = ArrayList<String>();
    variable Boolean allVerbose = false;
    // build module
    variable String buildModule = defaultModule;
    // goals and goal options (unused)
    ArrayList<String> goalsCollected = ArrayList<String>();
    ArrayList<String> goalOptions = ArrayList<String>();
    // parsing states
    variable Boolean goalsStarted = false;
    variable Boolean goalsFinished = false;
    // externally visible
    shared String moduleName;
    shared String moduleVersion;
    shared {String*} goals => goalsCollected;
    // constructor
    for (option in options) {
        if (goalsFinished) {
            goalOptions.add(option.string);
        } else if (goalsStarted && option is CommandLineOption) {
            goalsFinished = true;
            goalOptions.add(option.string);
        } else if (goalsStarted) {
            goalsCollected.add(option.string);
        } else if (is String option) {
            if (option.contains('/')) {
                buildModule = option;
            } else {
                goalsCollected.add(option);
            }
            goalsStarted = true;
        } else {
            switch (option.key)
            case ("--cacherep") {
                cacheRepository = option.val;
            }
            case ("--cwd") {
                currentWorkingDirectory = option.val;
            }
            case ("--define") {
                if(exists val = option.val) {
                    systemProperties.add(val);
                }
            }
            case ("--encoding") {
                encoding = option.val;
            }
            case ("--javac") {
                if(exists val = option.val) {
                    javacOptions.add(val);
                }
            }
            case ("--maven-overrides") {
                mavenOverrides = option.val;
            }
            case ("--no-default-repositories") {
                noDefaultRepositories = true;
            }
            case ("--offline") {
                offline = true;
            }
            case ("--rep") {
                if(exists val = option.val) {
                    repositories.add(val);
                }
            }
            case ("--resource") {
                if(exists val = option.val) {
                    resourceDirectories.add(val);
                }
            }
            case ("--source") {
                if(exists val = option.val) {
                    sourceDirectories.add(val);
                }
            }
            case ("--src") {
                if(exists val = option.val) {
                    sourceDirectories.add(val);
                }
            }
            case ("--suppress-warning") {
                if(exists val = option.val) {
                    supressWarnings.add(val);
                }
            }
            case ("--sysrep") {
                systemRepository = option.val;
            }
            case ("--timeout") {
                timeout = option.val;
            }
            case ("--verbose") {
                if(exists val = option.val) {
                    verbose.add(val);
                } else {
                    allVerbose = true;
                }
            }
            else {
                process.writeErrorLine("Unknown option '``option.key``'");
                process.exit(1);
            }
        }
    }
    if (sourceDirectories.size == 0) {
        sourceDirectories.add(defaultSourceDirectory);
    }
    if (exists i = buildModule.firstInclusion("/")) {
        moduleName = buildModule[0..i-1];
        moduleVersion = buildModule[i+1...];
    } else {
        moduleName = buildModule;
        moduleVersion = "";
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
        void addList(String optionString, ArrayList<String> variable) {
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
