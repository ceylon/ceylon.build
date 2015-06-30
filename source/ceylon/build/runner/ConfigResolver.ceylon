import com.redhat.ceylon.common.config {
    CeylonConfig
}
import java.io {
    File
}
import java.lang {
    JString=String,
    ObjectArray
}

class ConfigResolver(Arguments arguments) {
    
    File cwd = arguments.firstOption("cwd") exists then File(arguments.firstOption("cwd")) else File(".");
    CeylonConfig ceylonConfig = CeylonConfig.createFromLocalDir(cwd);
    
    shared String workingDirectory => cwd.string;
    
    shared Boolean flag(String? commandLineName, String? configName, Boolean defaultOption = false) {
        if (exists commandLineName, arguments.hasFlag(commandLineName)) {
            return true;
        }
        if (exists configName) {
            return ceylonConfig.getBoolOption(configName, defaultOption);
        }
        return defaultOption;
    }
    
    shared String? option(String? commandLineName, String? configName, String? defaultOption = null) {
        if (exists commandLineName) {
            String? commandLineOption = arguments.firstOption(commandLineName);
            if (exists commandLineOption) {
                return commandLineOption;
            }
        }
        if (exists configName) {
            String? configNameString = configName;
            String? configOption = ceylonConfig.getOption(configNameString);
            return configOption else defaultOption;
        }
        return defaultOption;
    }
    
    shared {String*} options(String? commandLineName, String? configName, {String*} defaultOptions = {}) {
        if (exists commandLineName) {
            {String*} commandLineOptions = arguments.allOptions(commandLineName);
            if (!commandLineOptions.empty) {
                return commandLineOptions;
            }
        }
        if (exists configName) {
            String? configNameStringNull = configName;
            ObjectArray<JString>? configOptions = ceylonConfig.getOptionValues(configNameStringNull);
            if (exists configOptions, configOptions.size != 0) {
                {JString*} jstringIterable = configOptions.iterable.coalesced;
                {String*} stringIterable = jstringIterable.map<String>((JString jString) => jString.string);
                return stringIterable;
            }
        }
        return defaultOptions;
    }
    
}
