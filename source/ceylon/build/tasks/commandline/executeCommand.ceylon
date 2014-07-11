import ceylon.build.task { GoalException }
import ceylon.file { current, Path }
import ceylon.process {
    Process, createProcess,
    Input, currentInput,
    Output, currentOutput,
    Error, currentError,
    currentEnvironment
}

"Returns a `Task` that will run the given command in a new a new process using [[executeCommand]].
 Returns true if process exit code is `0`, false otherwise."
see(`function executeCommand`)
shared void command(
        "The _command_ to be run in the new
         process, usually the name or path of a
         program. Command arguments must be passed
         via the [[arguments]] sequence."
        String command,
        "The arguments to the [[command]]."
        [String*] arguments = [],
        "The directory in which the process runs."
        Path path = current,
        "The source for the standard input stream
         of the process, or `null` if the standard
         input should be piped from the current
         process."
        Input? input = currentInput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard output should be piped to the
         current process."
        Output? output = currentOutput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard error should be piped to the
         current process."
        Error? error = currentError,
        "Environment variables to pass to the
         process. By default the process inherits
         the environment variables of the current
         virtual machine process."
        {<String->String>*} environment = currentEnvironment) {
    Integer exitCode = executeCommand(command, arguments, path,
        currentInput, currentOutput, currentError, environment) else 0;
    reportOutcome(exitCode, command, arguments, path);
}

"Creates and starts a new process, running the given command.
 Waits for process termination and returns its exit code."
see(`function createProcess`)
shared Integer? executeCommand(
        "The _command_ to be run in the new
         process, usually the name or path of a
         program. Command arguments must be passed
         via the [[arguments]] sequence."
        String command,
        "The arguments to the [[command]]."
        [String*] arguments = [],
        "The directory in which the process runs."
        Path path = current,
        "The source for the standard input stream
         of the process, or `null` if the standard
         input should be piped from the current
         process."
        Input? input = currentInput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard output should be piped to the
         current process."
        Output? output = currentOutput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard error should be piped to the
         current process."
        Error? error = currentError,
        "Environment variables to pass to the
         process. By default the process inherits
         the environment variables of the current
         virtual machine process."
        {<String->String>*} environment = currentEnvironment) {
    Process process = createProcess(command, arguments, path, input, output, error, *environment);
    process.waitForExit();
    return process.exitCode;
}

"Convert a command exit code into an Outcome.
 
 If `exitCode` is `0`, a successfull outcome will be returned.
 
 If `exitCode` is not `0`, a failure outcome will be returned with information about executed command."
shared void reportOutcome(Integer exitCode, String command, [String*] arguments, Path path = current) {
    if (exitCode != 0) {
        throw GoalException(
                "command:            ``command````arguments.empty then "" else " "````" ".join(arguments)``\n" +
                "working directory:  ``path``\n" +
                "exits with code:    ``exitCode``");
    }
}
