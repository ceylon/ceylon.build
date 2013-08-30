ceylon.build
============

Ceylon task based build system.

The goal of this module is to provide a task based build engine and common tasks.
It will also provide helpers to create your own tasks.

License
-------

The content of this repository is released under the ASL v2.0
as provided in the LICENSE file that accompanied this code.

By submitting a "pull request" or otherwise contributing to this repository, you
agree to license your contribution under the license mentioned above.

Compilation and tests
----------------------

* Compile task API module: `ceylon compile ceylon.build.task`
* Compile task API test module: `ceylon compile test.ceylon.build.tasks --src=test-source`
* Run task API module tests: `ceylon run test.ceylon.build.task`

* Compile engine module: `ceylon compile ceylon.build.engine`
* Compile engine test module: `ceylon compile test.ceylon.build.engine --src=test-source`
* Run engine module tests: `ceylon run test.ceylon.build.engine`

* Compile command line task module: `ceylon compile ceylon.build.tasks.commandline`

* Compile Ceylon tasks module: `ceylon compile ceylon.build.tasks.ceylon`
* Compile Ceylon tasks test module: `ceylon compile test.ceylon.build.tasks.ceylon --src=test-source`
* Run Ceylon tasks module tests: `ceylon run test.ceylon.build.tasks.ceylon`

Usage
-----

Create a build module.
A build module is a standard ceylon module that has in its `run()` function a call to `build(TasksDefinitions)`.

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

When `yourbuildmodule` is launched, the engine will build the task graph and run requested tasks and their dependencies.

Using the above tasks declarations, launching `ceylon run yourbuildmodule/1.0.0 test doc` will result in the
execution of task `compile`, `compile-tests`, `test` and `doc` in this order.

Arguments can be passed to each task using the `-Dtask:argument` syntax.

For example, `compile` task has support for `--javac` argument and `doc` task for `--non-shared` and `--source-code`
arguments, then, the following command can be used:
`ceylon run mybuildmodule/1.0.0 test doc -Dcompile:--javac=-g:source,lines,vars -Ddoc:--non-shared -Ddoc:--source-code`

