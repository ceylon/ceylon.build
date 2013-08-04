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

* Compile the module: `ceylon compile ceylon.build`
* Compile tests: `ceylon compile test.ceylon.build --src=test-source`
* Run tests: `ceylon run test.ceylon.build/X.Y` where `X.Y` is the current test module version

Usage
-----

Create a build module.
A build module is a standard ceylon module that has in its `run()` function a call to `build(TasksDefinitions)`.

```ceylon
void run() {
    Task clean = createTask("clean", ...);
    Task compile = createTask("compile", ...);
    Task test = createTask("test", ...);
    Task doc = createTask("doc", ...);
    Task deploy = createTask("deploy", ...);
    build({
        clean -> [],
        compile -> [clean],
        test -> [compile],
        doc -> [],
        deploy -> [compile]
    });
}
```

When this build module is launched, it will build the task graph and run the requested tasks and their dependencies.

Using the above tasks declarations, launching `ceylon run mybuildmodule/1.0.0 test doc` will result in the execution of task `clean`, `compile`, `test` and `doc`.

Arguments can be passed to each task using the `-Dtask:argument`.

For example, if `test` task has support for `parallelTests` argument and `doc` task for `format` argument, then, the following command can be used:
`ceylon run mybuildmodule/1.0.0 test -Dtest:parallelTests=true doc -Ddoc:format=html,pdf`
