import ceylon.build.task { Writer }
import ceylon.build.tasks.commandline { executeCommand, reportOutcome }
import com.redhat.ceylon.common.tools { CeylonTool { start } }

"Executes ceylon command using given ceylon executable or `CeylonTool` if none is given"
void execute(Writer writer, String title, String? ceylon, [String+] arguments) {
    Integer exitCode;
    if (exists ceylon) {
        exitCode = executeInNewProcess(writer, title, ceylon, arguments);
    } else {
        exitCode = executeWithCurrentCeylonRuntime(arguments);
    }
    reportOutcome(exitCode, ceylon else "<ceylon>", arguments);
}

"Executes ceylon command using `CeylonTool`"
Integer executeWithCurrentCeylonRuntime([String+] command) {
    return start(*command);
}

"Executes ceylon command with given ceylon executable in a new process"
Integer executeInNewProcess(Writer writer, String title, String ceylon, [String+] arguments) {
    value commandToExecute = [ceylon, *arguments];
    writer.info("``title``: '``" ".join(commandToExecute)``'");
    return executeCommand(ceylon, arguments) else 0;
}
