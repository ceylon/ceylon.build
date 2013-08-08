"""Ceylon task based build system.
   
   The goal of this module is to provide a task based build engine with a set of common built-in tasks.
   
   It will also provide helpers to create your own tasks.
   
   --------
   
   A build module is a standard ceylon module that has in its `run()` function a call to `build(TasksDefinitions)`.
   
   ```ceylon
   import ceylon.build { build, CeylonModuleTaskBuilder }
   
   void run() {
       value ceylonTaskBuilder = CeylonModuleTaskBuilder("mymodule");
       value compile = ceylonTaskBuilder.createCompileTask();
       value test = ceylonTaskBuilder.createTestTask();
       value doc = ceylonTaskBuilder.createDocTask();
       value run = ceylonTaskBuilder.createRunTask();
       build({
           compile,
           test -> [compile],
           doc,
           run
       });
   }
   ```
   
   When this `yourbuildmodule` is launched, it will build the task graph and run requested tasks and their dependencies.
   
   Using the above tasks declarations, launching `ceylon run yourbuildmodule/1.0.0 test doc` will result in the
   execution of task `compile`, `test` and `doc` in this order.
   
   Arguments can be passed to each task using the `-Dtask:argument`.
   
   For example, if `test` task has support for `parallelTests` argument and `doc` task for `format` argument, then, the following command can be used:
   `ceylon run mybuildmodule/1.0.0 test -Dtest:parallelTests=true doc -Ddoc:format=html,pdf`"""
shared module ceylon.build '0.1' {
    import ceylon.collection '0.6';
    import ceylon.process '0.6';
}
