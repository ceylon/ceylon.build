import ceylon.build.task { Task, goal, include }
import ceylon.build.tasks.misc { echo }

goal { dependencies = ["compile"]; }
Task deploy() => echo("deploying");

goal
Task start() => echo("starting");

goal
Task stop() => echo("stopping");

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
    shared Task clean() => echo("cleaning modules/");
    
    goal
    shared {Task*} compile() => { echo("compiling ``name``"), echo("copying to local repository") };
    
    goal("compile-tests")
    shared Task compileTests() => echo("compiling test.``moduleVersion``");
    
    goal("run-tests")
    shared Task runTests() => echo("running test.``moduleVersion``");
    
    goal { dependencies = ["compile", "compile-tests", "run-tests"]; }
    shared {Task*} test() => {};
    
    goal
    shared Task doc() => echo("documenting");
}
