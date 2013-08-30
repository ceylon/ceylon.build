import ceylon.build.task { Writer }
import ceylon.build.tasks.commandline { executeCommand }

Boolean execute(Writer writer, String title, String command) {
    value commandToExecute = command.trimmed;
    writer.info("``title``: '``commandToExecute``'");
    Integer? exitCode = executeCommand(commandToExecute);
    return (exitCode else 0) == 0;
}
