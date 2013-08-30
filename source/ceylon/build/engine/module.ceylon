"""Ceylon task based build system.
   
   The goal of this module is to provide a task based build engine with a set of common built-in tasks.
   
   It will also provide helpers to create your own tasks.
   
   --------
   
   A build module is a standard ceylon module that has in its `run()` function a call to
   `build(String project, {Task+} tasks)`.
   
   ```ceylon
   import ceylon.build.engine { build }
   import ceylon.build.task { Task }
   import ceylon.build.tasks.ceylon { compile, compileTests, document, runModule }
   
   void run() {
       String myModule = "mod";
       String myTestModule = "test.mod";
       value compileTask = Task {
           name = "compile";
               compile {
               moduleName = myModule;
           };
       };
       value compileTestsTask = Task {
           name = "compile-tests";
           compileTests {
               moduleName = myTestModule;
           };
       };
       build {
           project = "My Build Project";
           compileTask,
           compileTestsTask,
           Task {
               name = "test";
               runModule {
                   moduleName = myTestModule;
                   version = "1.0.0";
               };
               dependencies = [compileTask, compileTestsTask];
           },
           Task {
               name = "doc";
               document {
                   moduleName = myModule;
                   includeSourceCode = true;
               };
           },
           Task {
               name = "run";
               runModule {
                   moduleName = myModule;
                   version = "1.0";
               };
           },
           Task {
               name = "publish-local";
               compile {
                   moduleName = myModule;
                   outputModuleRepository = "~/.ceylon/repo";
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
module ceylon.build.engine '0.1' {
    shared import ceylon.build.task '0.1';
    
    import ceylon.collection '0.6';
    
    import java.base '7'; // needed for regular expression support
    import ceylon.interop.java '0.6';
}
