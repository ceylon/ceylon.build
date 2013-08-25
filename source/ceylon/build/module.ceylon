"""Ceylon task based build system.
   
   The goal of this module is to provide a task based build engine with a set of common built-in tasks.
   
   It will also provide helpers to create your own tasks.
   
   --------
   
   A build module is a standard ceylon module that has in its `run()` function a call to `build(TasksDefinitions)`.
   
   ```ceylon
   import ceylon.build { Task, build }
   import ceylon.build.tasks.ceylon { compile, doc, test, runModule, ast, benchmark }
   
   void run() {
       value compileTask = Task {
           name = "compile";
           compile {
               moduleName = "mod";
               verboseModes = { ast, benchmark };
           };
       };
       build {
           project = "My Build Project";
           rootPath = ".";
           compileTask,
           Task {
               name = "test";
               test {
                   moduleName = "test.mod";
               };
               dependencies = [compileTask];
           },
           Task {
               name = "doc";
               doc {
                   moduleName = "mod";
               };
           },
           Task {
               name = "run";
               runModule {
                   moduleName = "mod";
                   version = "1.0";
               };
           }
       };
   }
   ```
   
   When this `yourbuildmodule` is launched, it will build the task graph and run requested tasks and their dependencies.
   
   Using the above tasks declarations, launching `ceylon run yourbuildmodule/1.0.0 test doc` will result in the
   execution of task `compile`, `test` and `doc` in this order.
   
   Arguments can be passed to each task using the `-Dtask:argument`.
   
   For example, `compile` task has support for `--javac` argument and `doc` task for `format` and `--source-code`
   arguments, then, the following command can be used:
   `ceylon run mybuildmodule/1.0.0 test doc -Dcompile:--javac=-g:source,lines,vars -Ddoc:--non-shared -Ddoc:--source-code`
   """
shared module ceylon.build '0.1' {
    import ceylon.collection '0.6';
    import ceylon.process '0.6';
    
    import java.base '7'; // needed for regular expression support
    import ceylon.interop.java '0.6';
}
