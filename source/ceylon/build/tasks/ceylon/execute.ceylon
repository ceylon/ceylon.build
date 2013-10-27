import ceylon.build.task { Writer, Outcome }
import ceylon.build.tasks.commandline { executeCommand, exitCodeToOutcome }

Outcome execute(Writer writer, String title, String command) {
    value commandToExecute = command.trimmed;
    writer.info("``title``: '``commandToExecute``'");
    Integer exitCode = executeCommand(commandToExecute) else 0;
    return exitCodeToOutcome(exitCode, commandToExecute);
}
