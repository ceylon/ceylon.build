import ceylon.language {
    license
}
"""This module defines the base elements of `ceylon.build` for declaring [[goal]]s.
   
   # Goal
   `ceylon.build.engine` is designed to work with [[goal]]s.

   A [[goal]] is a function that can be launched by the engine.
   It has a name and dependencies.
   
   - name is used in command line to request [[goal]] execution.
   - dependencies are [[goal]]s that will be executed before this [[goal]].
   
   ## Simple goal definition
   
   Here is an example of how to define a simple [[goal]]:
   
   ```ceylon
   goal
   shared void hello() {
       context.writer.info("Hello World!");
   }
   ```
   
   By default, the name of the [[goal]] will be the name of the function.
   But this can be manually specified in the [[goal]] annotation:
   
   ```ceylon
   goal("say-hello")
   shared void hello() {
       context.writer.info("Hello World!");
   }
   ```
   
   ## Failure
   
   It is possible that a [[goal]] operation will fail.
   
   This can be reported to the engine by throwing a [[GoalException]]
   ```ceylon
   goal
   shared void deploy() {
       Path source = ...
       Path destination = ...
       if (is Nil source.resource) {
           throw GoalException("artifact ``source`` does not exist");
       }
       copy(source, destination);
   }
   ```
   Other kind of exceptions can also be thrown but stacktrace will then be printed in engine output.
   This means that throwing [[GoalException]] should be preferred to other kinds of exceptions if
   you can provide a meaningful and understandble explanation of why the [[goal]] failed.
   
   ## Dependencies
   
   A [[goal]] can also define dependencies to other [[goal]]s.
   Dependencies will be executed (even if not explicitly requested) before all other [[goal]]s in the execution
   list that depend on those.
   
   ```ceylon
   goal
   shared void compile() {
       context.writer.info("compiling!");
   }
   goal
   dependsOn(`function compile`)
   shared void run() {
       context.writer.info("running!");
   }
   ```
   
   With the above code, requesting execution of `run` [[goal]] will result in execution of [[goal]]s `compile`
   followed by `run`.
   
   ## Goals without behaviors
   
   It is possible to define a [[goal]] that don't have any tasks like below:
   
   ```ceylon
   goal
   shared void test() {}
   ```
   
   Such a [[goal]] is useless, because it will not trigger any tasks execution.
   
   However, if dependencies are added it becomes a great way to group [[goal]]s.
   
   Requesting the execution of a such [[goal]] will cause the execution (as for any [[goal]]s) of all of its dependencies.
   The execution of those dependencies will be done in the order of declaration as long as
   dependencies between [[goal]]s of the current execution list are satisfied.
   If they are not, [[goal]]s will be re-ordered to satisfy dependencies.
   
   Here is an example:
   ```ceylon
   goal
   shared void compile() {
       context.writer.info("compiling");
   };
   
   goal
   shared void compileTests() {
       context.writer.info("compiling tests");
   };
   
   goal
   shared void runTests() {
       context.writer.info("running tests");
   };
   
   goal
   dependsOn(`function compile`, `function compileTests`, `function runTests`)
   shared void test() {};
   ```
   
   Execution of `test` will result in execution of [[goal]]s `compile`, `compileTests`, `runTests` and then `test`.
   
   But to avoid to pollute execution list with the `test` [[goal]] that will not do anything,
   we can rewrite the previous example as below:
   
   ```ceylon
   goal
   shared void compile() {
       context.writer.info("compiling");
   };
   
   goal
   shared void compileTests() {
       context.writer.info("compiling tests");
   };
   
   goal
   shared void runTests() {
       context.writer.info("running tests");
   };
   
   goal
   dependsOn(`function compile`, `function compileTests`, `function runTests`)
   shared NoOp test = noop;
   ```
   Execution of `test` will result in execution of [[goal]]s `compile`, `compileTests` and `runTests` but not `test` as
   the engine now understands that test is a [[noop]] [[goal]] and that it shouldn't be executed.
   
   Note that [[NoOp]] [[goal]]s can be used as dependencies as any other [[goal]]s.
   
   ## Indirect dependencies
   As we just saw, [[dependsOn]] annotation allow you to define that a [[goal]] A has a dependency on a [[goal]] B.
   
   [[attachTo]] annotation allow you to do the opposite by defining that a [[goal]] A is a dependency of [[goal]] B.
   
   This allows you to define [[goal]]s that can act as phases in your project.
   For example, you could define phases `compile`, `compileTests`, `test` as below:
   ```ceylon
   goal
   shared NoOp compile = noop;
   
   goal
   dependsOn(`function compile`)
   shared NoOp compileTests = noop;
   
   goal
   dependsOn(`function compileTests`)
   shared NoOp test = noop;
   ```
   
   and then declare jvm and js related [[goal]]s that will be attached to those phases:
   
   ```ceylon
   goal
   attachTo(`function compile`)
   shared void compileJvm() {
       context.writer.info("compiling for JVM");
   };
   
   goal
   attachTo(`function compile`)
   shared void compileJs() {
       context.writer.info("compiling for JS");
   };
   
   goal
   attachTo(`function compileTests`)
   shared void compileJvmTests() {
       context.writer.info("compiling tests for JVM");
   };
   
   goal
   attachTo(`function compileTests`)
   shared void compileJsTests() {
       context.writer.info("compiling tests for JS");
   };
   
   goal
   attachTo(`function test`)
   shared void testJvm() {
       context.writer.info("running JVM tests");
   };
   
   goal
   attachTo(`function test`)
   shared void testJs() {
       context.writer.info("running JS tests");
   };
   ```
   
   Execution of `test` will now result in execution of [[goal]]s `compileJvm`, `compileJs`,
   `compileJvmTests`, `compileJsTests`, `testJvm` and `testJs`
   
   Note that attaching a [[goal]] to another one with [[attachTo]] will not provide a
   direct dependency to destination dependencies.
   
   This means that in this example:
   
   - execution of `compileJvm` will result in execution of `compileJvm`.
   `compileJs` will not be included in the execution list.
   - execution of `compileJvmTests` will result in execution of `compileJvmTests`.
    To also execute `compileJvm`, a depedency from `compileJvmTests` to `compileJvm` is also needed.
   """
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.task "1.0.0" {}
