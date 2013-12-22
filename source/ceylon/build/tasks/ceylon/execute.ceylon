import ceylon.build.task { Writer, Outcome }
import ceylon.build.tasks.commandline { executeCommand, exitCodeToOutcome }
import com.redhat.ceylon.common.tools { CeylonTool { start } }

"Executes ceylon command using given ceylon executable or `CeylonTool` if none is given"
Outcome execute(Writer writer, String title, String? ceylon, [String+] command) {
    Integer exitCode;
    if (exists ceylon) {
        exitCode = executeInNewProcess(writer, title, ceylon, command);
    } else {
        exitCode = executeWithCurrentCeylonRuntime(command);
    }
    return exitCodeToOutcome(exitCode, "``ceylon else "<ceylon>"`` ``command``");
}

"Executes ceylon command using `CeylonTool`"
Integer executeWithCurrentCeylonRuntime([String+] command) {
    return start(*command);
}

"Executes ceylon command with given ceylon executable in a new process"
Integer executeInNewProcess(Writer writer, String title, String ceylon, [String+] command) {
    value commandToExecute = [ceylon, *command];
    writer.info("``title``: '``" ".join(commandToExecute)``'");
    return executeCommand(commandToExecute) else 0;
}
