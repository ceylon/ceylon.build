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
---------------------
To build and install `ceylon.build` run following command: `ant clean publish`

To run the tests: `ant test`


`ceylon.build` is composed of following modules:
### Goal/Task API:
API to define your own `Goal`s

### Runner:
Command line interface launching the engine

### Engine:
Resolve goals dependencies and goals execution

### Command line tasks:
Tasks to launch a command in a new process

### Ceylon tasks:
Tasks to compile, run, test, document ceylon modules

### Files tasks:
Tasks to copy / delete files and directories

Usage
-----

Create a build module.
A build module is a standard ceylon module.
Convention is that it is located in a `build-source` folder and is named `build/1` so that `ceylon build`
command is able to find it without specifying its name/version.

This build module should contain function declarations annotated with `goal` annotation.

A `goal` is a function that can be launched by the engine with a name and dependencies
(possibly empty) to other goals.
A goal can be referenced by its name from command line.
   
Here is an example of how to define a simple `goal`:

```ceylon
goal
shared void hello() {
    print("Hello World!");
}
```
_More details are available in `ceylon.build.task` ceylon doc._

When `ceylon build` is launched, it will build the goal graph and run requested goals and their
dependencies.

Arguments can be passed to each goal task using the `-Dgoal:argument`.

For example, if `compile` goal has support for `--javac` argument and `doc` goal for `format` and `--source-code`
arguments, then, the following command can be used:
`ceylon build test doc -Dcompile:--javac=-g:source,lines,vars -Ddoc:--non-shared -Ddoc:--source-code`

Console
-------

A simple interractive console is provided for running top level goals defined in a module:

```ceylon
goal
shared void echo() {
    print("Hello World!");
}
```
To start the console, launch command `ceylon build --console`
```
    Available goals:
    echo
    
    > echo
    ## ceylon.build: 
    # running goals: [echo] in order
    # running echo()
    Hello World
    ## success - duration 0s
    Success
```

