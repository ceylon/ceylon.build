import ceylon.test { test, assertEquals }
import ceylon.build.tasks.ceylon { ceylonJvmModule }

// TODO rewrite those tests
//test void shouldHaveOnlyDocGoal() {
//    value goalset = ceylonModule {
//        moduleName = "moduleName";
//        target = Target { jvm = false; javascript = false; };
//    };
//    value goals = goalset.goals;
//    assertEquals(names(goals), ["doc"]);
//}
//
//test void shouldHaveJVMAndDocGoals() {
//    value goalset = ceylonModule {
//        moduleName = "moduleName";
//        target = Target { jvm = true; javascript = false; };
//    };
//    value goals = goalset.goals;
//    assertEquals(names(goals), ["compile", "compile-tests", "run-tests", "test", "doc"]);
//}
//
//test void shouldHaveJsAndDocGoals() {
//    value goalset = ceylonModule {
//        moduleName = "moduleName";
//        target = Target { jvm = false; javascript = true; };
//    };
//    value goals = goalset.goals;
//    assertEquals(names(goals), ["compile-js", "compile-js-tests", "run-js-tests", "test-js", "doc"]);
//}
//
//test void shouldHaveJVMAndJsAndDocGoals() {
//    value goalset = ceylonModule {
//        moduleName = "moduleName";
//        target = Target { jvm = true; javascript = true; };
//    };
//    value goals = goalset.goals;
//    assertEquals(names(goals), [
//        "compile", "compile-tests", "run-tests", "test",
//        "compile-js","compile-js-tests", "run-js-tests", "test-js",
//        "doc"]);
//}
//
//test void shouldRenameGoals() {
//    value goalset = ceylonModule {
//        moduleName = "moduleName";
//        rename = suffix(".mod");
//    };
//    value goals = goalset.goals;
//    assertEquals(names(goals), [
//        "compile.mod","compile-tests.mod", "run-tests.mod", "test.mod",
//        "compile-js.mod","compile-js-tests.mod", "run-js-tests.mod", "test-js.mod",
//        "doc.mod"]);
//}
//
//{String*} names({Goal+} goals) => [ for (goal in goals) goal.name];