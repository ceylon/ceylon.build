import ceylon.build.task { Task, goal, include, Outcome, Context, done }
import ceylon.build.tasks.misc { echo }

goal
void reallySimpleTask() {
    print("hello");
}

goal
Outcome simpleTask(Context context) {
    context.writer.info("hello");
    return done;
}

goal
Task taskImportValue = echo("hello");

goal
{Task*} tasksImportValue = {
    echo("hello"),
    echo("hello")
};

goal { dependencies = ["compile"]; }
void deploy() {
    print("deploying");
}

goal
Outcome start(Context context) {
    context.writer.info("starting");
    return done;
}

goal
{Task*} restart => {
    echo("stopping (fast)"),
    echo("starting (fast)")
};

goal
Task stop => echo("stopping");

include {
// #Desired syntax for goal name renaming in include annotation.
// #Waiting for support of class Entry in annotations
//    //goals = {
//    //    `function CeylonModule.compileTests` -> "compile.tests",
//    //    `function CeylonModule.runTests` -> "run.tests"
//    //};
}
shared CeylonModule ceylon => CeylonModule("mymodule", "1.0.0");

// In practice, this class will not belong to the build module
// but to an external tasks module and will be imported in the
// build module using `include` annotation.
shared class CeylonModule(String name, String version) {
    
    String moduleVersion = "``name``/``version``";
    
    goal
    shared void clean() {
        print("cleaning modules/");
    }
    
    goal
    shared {Task*} compile = {
        echo("compiling ``name``"),
        echo("copying to local repository")
    };
    
    goal("compile-tests")
    shared Task compileTests = echo("compiling test.``moduleVersion``");
    
    goal("run-tests")
    shared Task runTests = echo("running test.``moduleVersion``");
    
    goal { dependencies = ["compile", "compile-tests", "run-tests"]; }
    shared {Task*} test = {};
    
    goal
    shared Outcome doc(Context context) {
        context.writer.info("documenting");
        return done;
    }
}
