"""The goal of this module is to provide a goal/task based build engine to achieve actions.
   It could be used to handle development tasks like compile, test, document, run module,  ...
   or any other action like files copy, directory cleanup, ...
   
   
   `ceylon.build.engine` objective is to achieve requested goals by executing their
   associated task function and orchestrating their dependencies.
   
   More detailled documentation on how to create and use `Goal` and `GoalSet`
   can be found in module `ceylon.build.task`.
   
   # Build module
   
   A build module is a standard ceylon module that has in its `run()` function a call to
   `build(String project, {<Goal|GoalSet>+} goals)`.
   
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
               }
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
               }
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
   
   Sometimes, it is needed to always execute a goal before another one.
   In that case, the second goal can declare a dependency on the first one as below:
   ```ceylon
   import ceylon.build.engine { build }
   import ceylon.build.task { Goal }
   import ceylon.build.tasks.ceylon { compile, compileTests, document, runModule }
   
   void run() {
       String myModule = "mod";
       String myTestModule = "test.mod";
       Goal compileGoal = Goal {
           name = "compile";
           compile {
               compilationUnits = myModule;
           }
       };
       Goal compileTestsGoal = Goal {
           name = "tests-compile";
           dependencies = [compileGoal];
           compileTests {
               compilationUnits = myTestModule;
           }
       };
       Goal testGoal = Goal {
           name = "test";
           dependencies = [compileTestsGoal];
           runModule {
               moduleName = myTestModule;
               version = "1.0.0";
           }
       };
       Goal docGoal = Goal {
           name = "doc";
           document {
               modules = myModule;
               includeSourceCode = true;
           }
       };
       build {
           project = "My Build Project";
           compileGoal,
           compileTestsGoal,
           testGoal,
           docGoal
       };
   }
   ```
   
   In this example, `"tests-compile"` declares a dependency on `"compile"` and
   `"test"` declares a dependency on `"tests-compile"`.
   
   Executing `ceylon run mybuildmodule/1.0.0 test` will result in the execution
   of goals `"compile"`, `"tests-compile"` and `"test"` in order.
   As you can see, dependencies are recursives because not only direct dependencies
   of `"test"` are put in the execution list, but also indirect dependencies
   (dependencies of dependencies of ...)
   
   ## Goals re-ordering
   
   Another feature of the dependency resolution mechanism is that it will re-order
   goal execution list to satisfy dependencies.
   
   For example, executing `ceylon run mybuildmodule/1.0.0 test tests-compile compile`
   will result in the execution of goals `"compile"`, `"tests-compile"` and `"test"`
   in this order because it is the only execution order that satisfies dependencies.
   
   In a general way, goals will be executed in the order they are requested as long
   that it satisfies declared dependencies. Otherwise, dependencies, will be moved
   before in the execution list to restore consistency.
   
   ## Multiple goals occurences
   
   In case a goal is requested multiple times (could be directly, or by dependency to it),
   the engine ensures that it will be executed only once.
   
   Using previous example, executing `ceylon run mybuildmodule/1.0.0 test tests-compile compile`
   will result in the execution of goals `"compile"`, `"tests-compile` and `"test"` in this order.
   Even if `"compile"` and `"tests-compile"` are requested twice (once directly, and once per dependency)."""
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.engine "1.0.0" {
    shared import ceylon.build.task "1.0.0";
    
    import ceylon.collection "1.0.0";
    
    import java.base "7"; // needed for regular expression support
    import ceylon.interop.java "1.0.0";
}
