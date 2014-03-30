import ceylon.build.task { goal, dependsOn, include, context, GoalAnnotation }
import ceylon.build.tasks.misc { echo }
import ceylon.language.meta.declaration { Declaration }

shared class FooBar() {
    goal shared void foo() {
        echo("foo");
    }
    goal shared void bar() {
        echo("foo");
    }
}

"Say Hello"
goal shared void hello() {
    echo("hello");
}

"Say Bye"
goal shared void bye() {
    echo("bye");
}

goal
dependsOn(`function bar`)
shared void foo() {
    echo("foo");
}

goal
shared void bar() {
    echo("bar");
}

goal
void reallySimpleTask() {
    print("hello");
}

goal
void simpleTask() {
    context.writer.info("hello");
}

goal
void taskImport() {
     echo("hello");
}

goal
void tasksImports() {
    echo("hello");
    echo("hello");
}

goal
dependsOn(`function CeylonModule.compile`)
void deploy() {
    print("deploying");
}

goal
void start() {
    context.writer.info("starting");
}

goal
void restart() {
    echo("stopping (fast)");
    echo("starting (fast)");
}

goal
void stop() => echo("stopping");

shared class SubCeylonModule() extends CeylonModule("mymodule", "1.0.0") {
    
    goal("newname")
    shared actual void clean() => super.clean();
}

include {
// #Desired syntax for goal name renaming in include annotation.
// #Waiting for support of class Entry in annotations
//    //goals = {
//    //    `function CeylonModule.compileTests` -> "compile.tests",
//    //    `function CeylonModule.runTests` -> "run.tests"
//    //};
}
//shared object ceylon extends CeylonModule("mymodule", "1.0.0") {
//    
//    goal("newname")
//    shared actual void clean() => super.clean();
//}
shared SubCeylonModule ceylon = SubCeylonModule();

Declaration cleanDeclaration1 = `function CeylonModule.clean`;
//Declaration cleanDeclaration2 = `function ceylon.clean`;

// In practice, this class will not belong to the build module
// but to an external tasks module and will be imported in the
// build module using `include` annotation.
shared class CeylonModule(String name, String version) {
    
    String moduleVersion = "``name``/``version``";
    
    goal("oldname")
    shared default void clean() {
        print("cleaning modules/");
    }
    
    goal
    shared void compile() {
        echo("compiling ``name``");
        echo("copying to local repository");
    }
    
    goal("compile-tests")
    shared void compileTests() => echo("compiling test.``moduleVersion``");
    
    goal("run-tests")
    shared void runTests() => echo("running test.``moduleVersion``");
    
    goal //{ dependencies = ["compile", "compile-tests", "run-tests"]; }
    shared void test() {}
    
    goal
    shared void doc() {
        context.writer.info("documenting");
    }
}

void run() {
    print(`function CeylonModule.clean`.annotations<GoalAnnotation>());
    print(`function SubCeylonModule.clean`.annotations<GoalAnnotation>());
}
