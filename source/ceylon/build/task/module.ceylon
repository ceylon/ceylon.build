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
   
   ## Internal Goal
   
   All goals are accessible by their name through command line. However,
   you might want not to display some internal goals to the end-user.
   
   This can be controlled by the visibility of the annotated goal.
   If it is annotated with `shared`, then it will be displayed to the end user.
   If it isn't, it won't be shown in goals list but can still be launched if requested.
   
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
   you can provide a meaningful and understandable explanation of why the [[goal]] failed.
   
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
   
   # Plugins
   
   A `ceylon.build` plugin is a type that defines [[goal]]s members.
   It can be seen as a collection of [[goal]]s that can be imported together in the current build.
   Those [[goal]]s have the same features as toplevel [[goal]]s.
   
   ## Plugin creation
   
   A plugin can be a simple class
   ```ceylon
   shared class HelloPlugin(String name) {
       goal("say-hello")
       shared default void hello() => context.writer.info("hello ``name``");
       
       goal("say-goodbye")
       shared default void bye() => context.writer.info("goodbye ``name``");
   }
   ```
   a simple interface
   ```ceylon
   shared interface HelloPlugin {
       
       shared formal String name;
       
       goal("say-hello")
       shared default void hello() => context.writer.info("hello ``name``");
       
       goal("say-goodbye")
       shared default void bye() => context.writer.info("goodbye ``name``");
   }
   ```
   Or any combination of class, interface that can be instanciated.
   Actually, it's just a type.
   
   For example, all types below are a valid plugins
   ```ceylon
   shared interface I1 {
       goal
       shared void m1() {}
   }
   shared interface I2 satisfies I1 {
       goal
       shared void m2() {}
   }
   shared interface I3 {
       goal
       shared void m3() {}
   }
   shared class C4() satisfies I2 {
       goal
       shared void m4() {}
   }
   shared class C5() extends C4() satisfies I3 {
       goal
       shared void m5() {}
   }
   ```
   And as expected, available [[goal]]s on type `C5` are:
   - `m5` directly from `C5`
   - `m4` by inheritance from `C4`
   - `m3` by satisfied interface from `I3`
   - `m2` by inheritance from `C4` satisfying `I2`
   - `m1` by inheritance from `C4` satisfying `I2` satisfying `I1`
   In a general manner, all members annotated with [[goal]] in the type hierachy
   (superclasses or satisfies interfaces) will be imported in the build.
   
   ## Plugin usage
   
   To use a such plugin, you have to annotate a toplevel member with [[include]] annotation
   that instanciates the plugin.
   
   Two syntaxes can be used:
   
   ### Standard attribute syntax
   
   ```ceylon
   include
   shared CustomPlugin customPlugin = CustomPlugin();
   ```
   
   ### Object definition syntax
   
   ```ceylon
   include
   shared object customPlugin extends CustomPlugin() {}
   ```
   Second syntax allows for inplace refinement of `CustomPlugin` [[goal]]s.
   
   ### Refinement
   
   Sometimes, you want to modify one of the imported [[goal]]s from an [[include]] directive.
   This is as easy a method refinement.
   It can be done inplace (using object syntax) or by introducing a subclass.
   
   Following `HelloPlugin` plugin will be used for below examples:
   
   ```ceylon
   shared class HelloPlugin(String name) {
       goal("say-hello")
       shared default void hello() => context.writer.info("hello ``name``");
       
       goal("say-goodbye")
       dependsOn(`function hello`)
       shared default void bye() => context.writer.info("goodbye ``name``");
   }
   ```
   
   #### Changing imported goal name
   
   To change `hello` [[goal]] name from `say-hello` to just `hello`:
   
   ```ceylon
   include
   shared object greetings extends HelloPlugin("world") {
       goal("hello")
       shared actual void hello() => super.hello();
   }
   ```
   
   #### Modifying goal behavior
   
   To change `hello` [[goal]] behavior:
   
   ```ceylon
   include
   shared object greetings extends HelloPlugin("world") {
       goal("say-hello") // TODO, this shouldn't be necessary once Inherited annotations will be implemented
       shared actual void hello() => print("hello ``name``");
   }
   ```
   
   #### Add dependencies
   
   To add a dependency to `bye` [[goal]]:
   
   ```ceylon
   goal
   shared void hug() => context.writer.info("hug");
   
   include
   shared object greetings extends HelloPlugin("world") {
       goal("say-goodbye") // TODO, this shouldn't be necessary once Inherited annotations will be implemented
       dependsOn(`function hug`)
       shared actual void bye() => super.bye();
   }
   ```
   [[goal]] `bye` now have a dependency on `hello` and `hug` [[goal]]s.
   
   #### Attach to a super phase
   
   To add attach a [[goal]] to `bye` [[goal]]:
   
   ```ceylon
   goal
   attachTo(`function greetings.bye`)
   shared void hug() => context.writer.info("hug");
   
   include
   shared object greetings extends HelloPlugin("world") {}
   ```
   [[goal]] `bye` now have a dependency on `hello` and `hug` [[goal]]s.
   
   """
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.task "1.1.0" {}
