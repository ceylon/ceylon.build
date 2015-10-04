"""This modules provides functions to execute commands.
   
   The following example will create a task that when called will execute `git pull` command.
   ```ceylon
   Task updateTask = command("git pull");
   ```
   [[command]] function is a `Task` wrapper for [[executeCommand]] function.
   
   Commands are executed in a synchronous way. This means that both functions will wait
   for command to exit before returning.
   """
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
native("jvm")
module ceylon.build.tasks.commandline "1.1.1" {
    shared import ceylon.build.task "1.1.1";
    import ceylon.file "1.1.1";
    shared import ceylon.process "1.1.1";
}
