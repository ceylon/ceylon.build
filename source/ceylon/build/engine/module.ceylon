"""The goal of this module is to provide a goal/task based build engine to achieve actions.
   It could be used to handle development tasks like compile, test, document, run module,  ...
   or any other action like files copy, directory cleanup, ....
   
   
   `ceylon.build.engine` objective is to achieve requested goals by executing their
   associated task function and orchestrating their dependencies.
   
   More detailled documentation on how to create and use `Goal`, `GoalGroup` and `GoalSet`
   can be found in module `ceylon.build.task`.
   
   # Build module
   
   A build module is a standard ceylon module that has in its `run()` function a call to
   `build(String project, {<Goal|GoalGroup|GoalSet>+} goals)`.
   
   ```ceylon
   import ceylon.build.engine { build }
   import ceylon.build.task { Goal }
   import ceylon.build.tasks.ceylon { ceylonModule }
   import ceylon.build.tasks.file { delete, copy }
   import ceylon.file { parsePath }
   
   void run() {
       String myModule = "mod";
       build {
           project = "My Build Project";
           Goal {
               name = "clean";
               delete {
                   path = parsePath("modules/``myModule``");
               };
           },
           ceylonModule {
               moduleName = myModule;
               testModuleVersion = "1.0.0";
           },
           Goal {
               name = "publish-local";
               copy {
                   source = parsePath("modules/``myModule``");
                   destination = parsePath("/path/to/local/ceylon/repo/``myModule``");
                   overwrite = true;
               };
           }
       };
   }
   ```
   This simple build module defines two goals and one goal set.
   
   - `"clean"` goal deletes directory `"modules/mod"`
   - `"publish-local"` copies files from `"modules/mod"` to `"/path/to/local/ceylon/repo/mod"`
   - `ceylonModule` function returns a goal set containing `"compile"`, `"tests-compile"`,
   `"test"` and `"doc"` goals. Those goals are provided by `ceylon.build.tasks.ceylon` module
   to handle ceylon modules development lifecycle. 
   
   # Execution
   
   When this `yourbuildmodule` is launched, it will build the goal graph and run requested goal's task and their
   dependencies.
   
   Using the above goals declarations, launching `ceylon run yourbuildmodule/1.0.0 clean compile doc` will result
   in the execution of goal `"clean"`, `"compile"` and `doc` in this order.
   
   Arguments can be passed to each goal task using the `-Dgoal:argument` syntax.
   
   For example, `compile` task has support for `--javac` argument and `doc` task for `--non-shared` and
   `--source-code` arguments, then, the following command can be used:
   `ceylon run mybuildmodule/1.0.0 test doc -Dcompile:--javac=-g:source,lines,vars -Ddoc:--non-shared -Ddoc:--source-code`
   
   # Dependencies
   
   
   
   # Orchestration
   
   """
license("http://www.apache.org/licenses/LICENSE-2.0")
module ceylon.build.engine '0.1' {
    shared import ceylon.build.task '0.1';
    
    import ceylon.collection '0.6.1';
    
    import java.base '7'; // needed for regular expression support
    import ceylon.interop.java '0.6.1';
}
