import ceylon.language.meta.declaration { Module }
import ceylon.build.engine { runEngineFromDefinitions }

shared void run() {
    value arguments = process.arguments;
    "module should be provided"
    assert(exists name = arguments[0]);
    Module? mod = loadModule(name);
    if (exists mod) {
        value goals = readAnnotations(mod);
        value ceylonBuildArguments = arguments[1...];
        Integer exitCode;
        if (interactive(ceylonBuildArguments)) {
            exitCode = console(goals);
        } else {
            exitCode = runEngineFromDefinitions {
                goals = goals;
                arguments =  ceylonBuildArguments;
            }.exitCode;
        }
        process.exit(exitCode);
    } else {
        process.writeErrorLine("not found ``name``");
        process.exit(1);
    }
}
