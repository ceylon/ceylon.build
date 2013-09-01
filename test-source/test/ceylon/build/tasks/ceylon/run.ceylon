import ceylon.test { suite }

void run() {
    suite("ceylon.build.tasks.ceylon",
            "ceylon compile command" -> shouldCreateCompileCommand,
            "ceylon compile command with 'all' verbose flag" -> shouldCreateCompileCommandWithAllVerboseFlag,
            "ceylon compile command with all parameters specified" -> shouldCreateCompileCommandWithAllParametersSpecified,
            "ceylon compile-js command" -> shouldCreateCompileJsCommand,
            "ceylon compile-js command with all parameters specified" -> shouldCreateCompileJsCommandWithAllParametersSpecified,
            "ceylon doc command" -> shouldCreateDocCommand,
            "ceylon doc command with all parameters specified" -> shouldCreateDocCommandWithAllParametersSpecified,
            "ceylon run command" -> shouldCreateRunCommand,
            "ceylon run command with 'all' verbose flag" -> shouldCreateRunCommandWithAllVerboseFlag,
            "ceylon run command with all parameters specified" -> shouldCreateRunCommandWithAllParametersSpecified,
            "ceylon run-js command" -> shouldCreateRunJsCommand,
            "ceylon run-js command with all parameters specified" -> shouldCreateRunJsCommandWithAllParametersSpecified);
}