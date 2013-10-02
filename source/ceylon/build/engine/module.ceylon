"""Ceylon task based build system.
   
   The goal of this module is to provide a task based build engine with a set of common built-in tasks.
   
   It will also provide helpers to create your own tasks.
   
   --------
   A `Goal` is a `Task` with a name and dependencies (possibly empty) to other goals.
   A goal can be referenced by its name from command line.
   
   A build module is a standard ceylon module that has in its `run()` function a call to
   `build(String project, {Goal+} goals)`.
   
   ```ceylon
   import ceylon.build.engine { build }
   import ceylon.build.task { Goal }
   import ceylon.build.tasks.ceylon { compile, compileTests, document, runModule }
   
   void run() {
       String myModule = "mod";
       String myTestModule = "test.mod";
       value compileGoal = Goal {
           name = "compile";
               compile {
               moduleName = myModule;
           };
       };
       value compileTestsGoal = Goal {
           name = "compile-tests";
           compileTests {
               moduleName = myTestModule;
           };
       };
       build {
           project = "My Build Project";
           compileGoal,
           compileTestsGoal,
           Goal {
               name = "test";
               runModule {
                   moduleName = myTestModule;
                   version = "1.0.0";
               };
               dependencies = [compileGoal, compileTestsGoal];
           },
           Goal {
               name = "doc";
               document {
                   moduleName = myModule;
                   includeSourceCode = true;
               };
           },
           Goal {
               name = "run";
               runModule {
                   moduleName = myModule;
                   version = "1.0";
               };
           },
           Goal {
               name = "publish-local";
               compile {
                   moduleName = myModule;
                   outputModuleRepository = "~/.ceylon/repo";
               };
           }
       };
   }
   ```
   
   When this `yourbuildmodule` is launched, it will build the goal graph and run requested goal's task and their
   dependencies.
   
   Using the above goals declarations, launching `ceylon run yourbuildmodule/1.0.0 test doc` will result in the
   execution of goal `compile`, `test` and `doc` in this order.
   
   Arguments can be passed to each goal task using the `-Dgoal:argument`.
   
   For example, `compile` task has support for `--javac` argument and `doc` task for `format` and `--source-code`
   arguments, then, the following command can be used:
   `ceylon run mybuildmodule/1.0.0 test doc -Dcompile:--javac=-g:source,lines,vars -Ddoc:--non-shared -Ddoc:--source-code`
   """
license("http://www.apache.org/licenses/LICENSE-2.0")
module ceylon.build.engine '0.1' {
    shared import ceylon.build.task '0.1';
    
    import ceylon.collection '0.6.1';
    
    import java.base '7'; // needed for regular expression support
    import ceylon.interop.java '0.6.1';
}
