import ceylon.build.task { Context }
import ceylon.test { assertEquals, test }

//Task noopTask = (Context context) => done;
//
//Task helloTask = function(Context context) {
//    print("hello");
//    return done;
//};
//
//Task byeTask = function(Context context) {
//    print("bye");
//    return done;
//};
//
//Goal createTestGoal(String name) {
//    return Goal(name, [noopTask]);
//}
//
//test void shouldHaveGivenName() {
//    assertEquals("MyGoal", createTestGoal("MyGoal").name);
//}
//
//void holdTasks([Task*] givenTasks) {
//    Goal myGoal = Goal("MyGoal", givenTasks);
//    assertEquals(givenTasks, myGoal.tasks);
//}
//
//test void shouldHaveNoTasks() {
//    value givenTasks = [];
//    holdTasks(givenTasks);
//}
//
//test void shouldHoldGivenTask() {
//    value givenTasks = [helloTask];
//    holdTasks(givenTasks);
//}
//
//test void shouldHoldMultipleTasks() {
//    value givenTasks = [helloTask, byeTask];
//    holdTasks(givenTasks);
//}
//
//test void shouldHaveNoDependenciesByDefault() {
//    Goal myGoal = Goal("MyGoal");
//    assertEquals([], myGoal.dependencies);
//}
//
//test void shouldHoldDependencies() {
//    Goal firstDependency = createTestGoal("firstDependency");
//    Goal secondDependency = createTestGoal("secondDependency");
//    value dependencies = [firstDependency, secondDependency];
//    Goal myGoal = Goal {
//        name = "MyGoal";
//        dependencies = dependencies;
//    };
//    assertEquals(dependencies, myGoal.dependencies);
//}
