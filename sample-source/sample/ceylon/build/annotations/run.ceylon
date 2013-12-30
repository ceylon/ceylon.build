import ceylon.build.task { Task, goal }
import ceylon.build.tasks.misc { echo }

goal { internal = true; }
Task clean() => echo("cleaning");

goal { dependencies = ["clean"]; }
Task compile() => echo("compiling");

goal("compile-tests")
Task compileTests() => echo("compiling tests");

goal("run-tests")
Task runTests() => echo("compiling tests");

goal {
    dependencies = [
        "compile", "compile-tests", "run-tests"
        //`function compile`,
        //`function compileTests`,
        //`function runTests`
    ];
}
{Task*} test() => {};

goal
Task doc() => echo("documenting");

