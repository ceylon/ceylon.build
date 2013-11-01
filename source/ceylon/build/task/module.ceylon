"""This module defines the base elements of `ceylon.build` for declaring goals and tasks.
   
   # Goal
   `ceylon.build.engine` is designed to work with goals.

   A [[Goal]] represents an action that can be launched by the engine.
   It has a name and a tasks list.
   - `Goal.name` is used in command line to ask for a goal execution.
   - `Goal.tasks` is a list of operations that will be executed in order when the goal name is specified.
   - `Goal.dependencies` is a list of goals that must be executed before current goal's tasks.
   
   ## Simple goal definition
   Here is an example of how to define a simple `Goal`:
   ```ceylon
   Goal hello = Goal {
       name = "hello";
       function(Context context) {
           context.writer.info("Hello World!");
           return done;
       }
   };
   ```
   ## Task definition
   A [[Task]] is an operation that will be executed when the goal name is specified.
   
   It takes a [[Context]] in input and returns an [[Outcome]] object telling if task execution succeed or failed.
   
   Here is an example of a simple task that will display `"Hello World!"` message:
   ```ceylon
   Outcome helloTask(Context context) {
       context.writer.info("Hello World!");
       return done;
   }
   ```
   
   A task can also return a success / failure message
   ```ceylon
   Outcome myTask(Context context) {
       try {
           processMyXXXTask();
           return Success("operation xxx done");
       } catch (Exception exception) {
           return Failure("failed to do xxx", exception);
       }
   }
   ```
   
   ## Goal with multiple tasks
   A goal can have several tasks.
   
   ```ceylon
   Goal myGoal = Goal {
       name = "myGoal";
       function(Context context) {
           context.writer.info("starting");
           return done;
       },
       function(Context context) {
           context.writer.info("running");
           return done;
       },
       function(Context context) {
           context.writer.info("stopping");
           return done;
       }
   };
   ```
   They will all be executed in order when goal execution is requested.
   If one of the tasks fails, execution will stop and failure will be reported.
   
   ## Dependencies
   A goal can also define dependencies to other goals.
   Dependencies will be executed (even if not explicitly requested) before all other goals in the execution
   list that depend on those.
   
   
   ```ceylon
   Goal compile = Goal {
       name = "compile";
       function(Context context) {
           context.writer.info("compiling!");
           return done;
       }
   };
   Goal run = Goal {
       name = "run";
       dependencies = [compile];
       function(Context context) {
           context.writer.info("running!");
           return done;
       }
   };
   ```
   With the above code, requesting execution of `run` goal will result in execution of goals `compile`
   followed by `run`.
   
   ## Goals without tasks
   It is possible to define a goal that don't have any tasks like below:
   ```ceylon
   Goal testGoal = Goal {
       name = "test";
   };
   ```
   Such a goal is useless, because it will not trigger any tasks execution.
   
   However, if dependencies are added it becomes a great way to group goals.
   
   Requesting the execution of a such goal will cause the execution (as for any goals) of all of its dependencies.
   The execution of those dependencies will be done in the order of declaration as long as
   dependencies between goals of the current execution list are satisfied.
   If they are not, goals will be re-ordered to satisfy dependencies.
   
   Here is an example:
   ```ceylon
   Goal compileGoal = Goal {
       name = "compile";
       compile {
           compilationUnits = "my.module";
       }
   };
   Goal compileTestsGoal = Goal {
       name = "compile-tests";
       compileTests {
           compilationUnits = "test.my.module";
       }
   };
   Goal runTestsGoal = Goal {
       name = "run-tests";
       runModule {
           moduleName = "test.my.module";
           version = "1.0.0";
       }
   };
   Goal testGoal = Goal {
       name = "test";
       dependencies = [compileTestsGoal, runTestsGoal];
   };
   ```
   Execution of `testGoal` will result in execution of goals `compileTestsGoal` followed by `runTestsGoal`.
   
   As a goals without tasks is like any other goal from a dependency point of view, it can be used as a
   dependency which enables interesting constructions like below:
   ```ceylon
   Goal fullBuild = Goal {
       name = "full-build";
       dependencies = [compileGoal, test];
   };
   ```
   Execution of `fullBuild` will trigger execution of `compileGoal`, `compileTestsGoal` and then `runTestsGoal`.
   
   # GoalSet
   A [[GoalSet]] is a set of goals that can be imported in a build configuration.
   
   For example, if a `ceylonModule` goal set provides goals to compile, compile tests, run tests
   and document a ceylon module and you have differents ceylon modules in your build, then,
   you are likely to want to rename `"compile"`, `"tests-compile"`, `"test"` and `"doc"` to something
   like `"compile.mymodule1"`, `"tests-compile.mymodule1"`, ...
   
   Here is an example of goal set definition from `ceylon.build.tasks.ceylon` module   
   ```ceylon
   "Returns a `GoalSet` providing compile, tests-compile, test and doc goals for a ceylon module."
   shared GoalSet ceylonModule(
           "module name"
           String moduleName,
           "test module name"
           String testModuleName = "test.``moduleName``",
           "test module version"
           String testModuleVersion = "1.0.0",
           "rename function that will be applied to each goal name."
           String(String) rename = keepCurrentName()) {
       return GoalSet {
           Goal {
               name = rename("compile");
               compile {
                   compilationUnits = moduleName;
               }
           },
           Goal {
               name = rename("tests-compile");
               compile {
                   compilationUnits = testModuleName;
                   sourceDirectories = testSourceDirectory;
               }
           },
           Goal {
               name = rename("test");
               runModule {
                   moduleName = testModuleName;
                   version = testModuleVersion;
               }
           },
           Goal {
               name = rename("doc");
               document {
                   modules = moduleName;
               }
           }
       };
   }
   ```
   It can be used as following:
   ```ceylon
   GoalSet ceylonModuleA = ceylonModule {
       moduleName = "moduleA";
       rename = suffix(".a");
   };
   GoalSet ceylonModuleB = ceylonModule {
       moduleName = "moduleB";
       rename = suffix(".b");
   };
   ```
   This will import goals `"compile.a"`, `"tests-compile.a"`, `"test.a"`, `"doc.a"`,
   `"compile.b"`, `"tests-compile.b"`, `"test.b"`, `"doc.b"` in the build configuration.
   """
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.task "1.0.0" {}
