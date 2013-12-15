import ceylon.build.task { Context, Task, Outcome, Failure, done, Writer }
import ceylon.process { Process, createProcess, currentInput, currentEnvironment }
import ceylon.file { current, Path }

"Returns a `Task` that will run the given command in a new a new process using [[executeCommand]].
 Task will report success if process exit code is `0`, otherwise, it will report a failure."
see(`function executeCommand`)
shared Task command(
        "The _command_ to be run in the new
         process, usually a program with a list
         of its arguments."
        String command,
        "The directory in which the process runs."
        Path path = current,
        "Environment variables to pass to the
         process. By default the process inherits
         the environment variables of the current
         virtual machine process."
        {<String->String>*} environment = currentEnvironment) {
    return function(Context context) {
        Integer exitCode = executeCommand(command, context.writer, path, environment) else 0;
        return exitCodeToOutcome(exitCode, command, path);
    };
}

"Creates and starts a new process, running the given command.
 Waits for process termination and returns its exit code."
see(`function createProcess`)
shared Integer? executeCommand(
        "The _command_ to be run in the new
         process, usually a program with a list
         of its arguments."
        String command,
        "The writer to which output and error messages will be written."
        Writer writer,
        "The directory in which the process runs."
        Path path = current,
        "Environment variables to pass to the
         process. By default the process inherits
         the environment variables of the current
         virtual machine process."
        {<String->String>*} environment = currentEnvironment) {
    Process process = createProcess(command.trimmed, path, currentInput, null, null, *environment);
    pipeOutputs(process, writer);
    process.waitForExit();
    return process.exitCode;
}

"Convert a command exit code into an Outcome.
 
 If `exitCode` is `0`, a successfull outcome will be returned.
 
 If `exitCode` is not `0`, a failure outcome will be returned with information about executed command."
shared Outcome exitCodeToOutcome(Integer exitCode, String command, Path path = current) {
    if (exitCode == 0) {
        return done;
    } else {
        return Failure(
                "command:            ``command``\n" +
                "working directory:  ``path``\n" +
                "exits with code:    ``exitCode``");
    }
}
