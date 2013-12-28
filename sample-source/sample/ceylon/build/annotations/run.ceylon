import ceylon.build.task { Task, goal }
import ceylon.build.tasks.misc { echo }

goal
Task clean() => echo("cleaning");

goal
Task compile() => echo("compiling");

goal("compile-tests")
Task compileTests() => echo("compiling tests");

goal("run-tests")
Task runTests() => echo("compiling tests");

goal {
    name = "test";
    dependencies = [
        `function compile`,
        `function compileTests`,
        `function runTests`
    ];
}
{Task*} test() => {};

goal
Task doc() => echo("documenting");

