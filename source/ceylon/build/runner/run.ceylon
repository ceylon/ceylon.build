import ceylon.language.meta.declaration { Module }
import ceylon.build.engine { GoalDefinitionsBuilder, runEngineFromDefinitions, consoleWriter }
import ceylon.build.task { Writer }

shared void run() {
    value writer = consoleWriter;
    value arguments = process.arguments;
    "module should be provided"
    assert(exists name = arguments[0]);
    Module? mod = loadModule(name);
    if (exists mod) {
        value goals = readAnnotations(mod);
        Integer exitCode;
        switch (goals)
        case (is GoalDefinitionsBuilder){
            exitCode = start(goals, writer, arguments);
        } case (is [InvalidGoalDeclaration+]) {
            reportInvalidDeclarations(goals, writer);
            exitCode = 1;
        }
        process.exit(exitCode);
    } else {
        process.writeErrorLine("Module '``name``' not found");
        process.exit(1);
    }
}

Integer start(GoalDefinitionsBuilder goals, Writer writer, [String*] arguments) {
    Integer exitCode;
    value ceylonBuildArguments = arguments[1...];
    if (interactive(ceylonBuildArguments)) {
        exitCode = console(goals, writer);
    } else {
        value result = runEngineFromDefinitions {
            goals = goals;
            arguments =  ceylonBuildArguments;
        };
        exitCode = result.exitCode;
    }
    return exitCode;
}

void reportInvalidDeclarations([InvalidGoalDeclaration+] invalidDeclarations, Writer writer) {
    writer.error("Invalid goals declarations:");
    for (invalid in invalidDeclarations) {
        writer.error(" - ``unsupportedSignature(invalid)``");
    }
    writer.error(
        """Valid signature for goals function are:
            - `void()`: a simple task that doesn't need access to `Context` object or report failures
            - `Outcome(Context)`: a simple task function
            - `Task()`: A delegate function that returns a task
            - `{Task*}()`: A delegate function that returns a list of tasks""");
}



String unsupportedSignature(InvalidGoalDeclaration invalid) {
    value declaration = invalid.declaration;
    return "Unsupported signature for goal annotated function ```declaration.name```";
}
