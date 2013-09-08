ceylon.build
============

Ceylon task based build system.

The goal of this module is to provide a goal/task based build engine and common tasks.
It will also provide helpers to create your own tasks.

License
-------

The content of this repository is released under the ASL v2.0
as provided in the LICENSE file that accompanied this code.

By submitting a "pull request" or otherwise contributing to this repository, you
agree to license your contribution under the license mentioned above.

Compilation and tests
----------------------
Goal/Task API:
* Compile task API module: `ceylon compile ceylon.build.task`
* Compile task API test module: `ceylon compile test.ceylon.build.tasks --src=test-source`
* Run task API module tests: `ceylon run test.ceylon.build.task`

Engine:
* Compile engine module: `ceylon compile ceylon.build.engine`
* Compile engine test module: `ceylon compile test.ceylon.build.engine --src=test-source`
* Run engine module tests: `ceylon run test.ceylon.build.engine`

Command line tasks:
* Compile command line task module: `ceylon compile ceylon.build.tasks.commandline`

Ceylon tasks:
* Compile Ceylon tasks module: `ceylon compile ceylon.build.tasks.ceylon`
* Compile Ceylon tasks test module: `ceylon compile test.ceylon.build.tasks.ceylon --src=test-source`
* Run Ceylon tasks module tests: `ceylon run test.ceylon.build.tasks.ceylon`

Files tasks:
* Compile command line task module: `ceylon compile ceylon.build.tasks.commandline`

Usage
-----

Create a build module.
A build module is a standard ceylon module that has in its `run()` function a call to
`build(String project, {Goal+} goals)`.

A `Goal` is a `Task` with a name and dependencies (possibly empty) to other goals.
A goal can be referenced by its name from command line.

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

