"""This module defines the base elements of `ceylon.build` for declaring goals and tasks.
   
   # Goal
   `ceylon.build.engine` is designed to work with goals.

   A [[Goal]] represents an action that can be launched by the engine.
   It has a name and a task.
   - `Goal.name` is used in command line to ask for a goal execution.
   - `Goal.task` is the operation that will be executed when the goal name is specified.
   
   ## Simple goal definition
   Here is an example of how to define a simple `Goal`:
   ```ceylon
   Goal hello = Goal {
       name = "hello";
       task = function(Context context) {
           context.writer.info("Hello World!");
           return true;
       };
   };
   ```
   ## Task definition
   A [[Task]] is the operation that will be executed when the goal name is specified.
   
   It takes a [[Context]] in input and returns a `Boolean` telling if task execution succeed or failed.
   
   Here is an example of a simple task that will display `"Hello World!"` message:
   ```ceylon
   task = function(Context context) {
       context.writer.info("Hello World!");
       return true;
   };
   ```
   
   ## Dependencies
   A goal can also define dependencies to other goals.
   Dependencies will be executed (even if not explicitly requested) before all other goals in the execution
   list that depend on those.
   
   
   ```ceylon
   Goal compile = Goal {
       name = "compile";
       task = function(Context context) {
           context.writer.info("compiling!");
           return true;
       };
   };
   Goal run = Goal {
       name = "run";
       task = function(Context context) {
           context.writer.info("running!");
           return true;
       };
       dependencies = [compile];
   };
   ```
   With the above code, requesting execution of `run` goal will result in execution of goals `compile`
   followed by `run`.
   
   # GoalGroup
   A [[GoalGroup]] is a group of goals (or other goal groups) that are grouped together with a name.
   
   Requesting the execution of a GoalGroup will cause the execution of all of the contained goals.
   
   The execution of those goals will be done in the order of declaration in the group as long as
   dependencies between goals of the current execution list are satisfied.
   
   If they are not, goals will be re-ordered to satisfy dependencies.
   
   Here is an example of a simple goal group:
   ```ceylon
   Goal compileGoal = Goal {
       name = "compile";
       compileTests {
           compilationUnits = "my.module";
       };
   };
   Goal compileTestsGoal = Goal {
       name = "compile-tests";
       compileTests {
           compilationUnits = "test.my.module";
       };
   };
   Goal runTestsGoal = Goal {
       name = "run-tests";
       runModule {
           moduleName = "test.my.module";
           version = "1.0.0";
       };
   };
   GoalGroup test = GoalGroup {
       name = "test";
       compileTestsGoal,
       runTestsGoal
   };
   ```
   Execution of `test` will result in execution of goals `compileTestsGoal` followed by `runTestsGoal`.
   
   As a goal group can also group existing goal groups, the following goal group can be created:
   ```ceylon
   GoalGroup fullBuild = GoalGroup {
       name = "full-build";
       compileGoal,
       test
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
               };
           },
           Goal {
               name = rename("tests-compile");
               compile {
                   compilationUnits = testModuleName;
                   sourceDirectories = testSourceDirectory;
               };
           },
           Goal {
               name = rename("test");
               runModule {
                   moduleName = testModuleName;
                   version = testModuleVersion;
               };
           },
           Goal {
               name = rename("doc");
               document {
                   modules = moduleName;
               };
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
license("http://www.apache.org/licenses/LICENSE-2.0")
module ceylon.build.task '0.1' {}
