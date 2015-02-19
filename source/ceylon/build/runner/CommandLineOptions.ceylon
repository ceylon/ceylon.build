import ceylon.collection {
    ArrayList
}

CommandLineOptions commandLineOptions() {
    value arguments = parseProcessArguments();
    return CommandLineOptions(arguments);
}

{CommandLineOption|String*} parseProcessArguments(String[] arguments = process.arguments) {
    if (arguments.contains("--version")) {
        print("Ceylon Build `` `module`.version ``");
        process.exit(0);
    }
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
   
   The option `buildModule` is required and set to `--buildmodule`.
   `goals` contain the called goals.
   `goalOptions` contain options for the goals (not used currently)
   
   The other options are the standard compiler options defined by [[ceylon.build.tasks.ceylon::compile]].
   
"""
class CommandLineOptions({CommandLineOption|String*} options) {
    
    shared variable String? encoding = null;
    
    shared ArrayList<String> sourceDirectories = ArrayList<String>();
    
    shared ArrayList<String> resourceDirectories = ArrayList<String>();
    
    shared variable String? javacOptions = null;
    
    shared ArrayList<String> repositories = ArrayList<String>();
    
    shared variable String? systemRepository = null;
    
    shared variable String? cacheRepository = null;
    
    shared variable Boolean offline = false;
    
    shared variable Boolean noDefaultRepositories = false;
    
    shared ArrayList<String->String> systemProperties = ArrayList<String->String>();
    
    shared variable String? currentWorkingDirectory = null;
    
    shared variable String? buildModule = null;
    
    shared ArrayList<String> goals = ArrayList<String>();
    
    shared ArrayList<String> goalOptions = ArrayList<String>();
    
    variable Boolean goalsStarted = false;
    variable Boolean goalsFinished = false;
    for (option in options) {
        if (goalsFinished) {
            goalOptions.add(option.string);
        } else if (goalsStarted && option is CommandLineOption) {
            goalsFinished = true;
            goalOptions.add(option.string);
        } else if (goalsStarted) {
            goals.add(option.string);
        } else if (is String option) {
            buildModule = option;
            goalsStarted = true;
        } else {
            switch (option.key)
            case ("--encoding") {
                encoding = option.val;
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
            case ("--resource") {
                if(exists val = option.val) {
                    resourceDirectories.add(val);
                }
            }
            case ("--javac") {
                javacOptions = option.val;
            }
            case ("--rep") {
                if(exists val = option.val) {
                    repositories.add(val);
                }
            }
            case ("--sysrep") {
                systemRepository = option.val;
            }
            case ("--cacherep") {
                cacheRepository = option.val;
            }
            case ("--offline") {
                offline = true;
            }
            case ("--no-default-repositories") {
                noDefaultRepositories = true;
            }
            case ("--define") {
                if(exists val = option.val) {
                    if (exists index = val.firstIndexWhere('='.equals)) {
                        systemProperties.add(val[... index-1] -> val[index+1 ...]);
                    } else {
                        systemProperties.add(val -> "");
                    }
                }
            }
            case ("--cwd") {
                currentWorkingDirectory = option.val;
            }
            else {
                process.writeErrorLine("Unknown option '``option.key``'");
                process.exit(1);
            }
        }
    }
    
}
