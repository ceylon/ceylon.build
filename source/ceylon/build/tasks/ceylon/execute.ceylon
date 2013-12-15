import ceylon.build.task { Writer, Outcome }
import ceylon.build.tasks.commandline { executeCommand, exitCodeToOutcome }
import com.redhat.ceylon.common.tools { CeylonTool { start } }

"Executes ceylon command using given ceylon executable or `CeylonTool` if none is given"
Outcome execute(Writer writer, String title, String? ceylon, String command) {
    value trimmedCommand = command.trimmed;
    Integer exitCode;
    if (exists ceylon) {
        exitCode = executeInNewProcess(writer, title, ceylon, trimmedCommand);
    } else {
        exitCode = executeWithCurrentCeylonRuntime(trimmedCommand);
    }
    return exitCodeToOutcome(exitCode, "``ceylon else "<ceylon>"`` ``trimmedCommand``");
}

"Executes ceylon command using `CeylonTool`"
Integer executeWithCurrentCeylonRuntime(String command) {
    return start(*command.split());
}

"Executes ceylon command with given ceylon executable in a new process"
Integer executeInNewProcess(Writer writer, String title, String ceylon, String command) {
    value commandToExecute = "``ceylon`` ``command.trimmed``";
    writer.info("``title``: '``commandToExecute``'");
    return executeCommand(commandToExecute, writer) else 0;
}
