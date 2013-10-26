import ceylon.build.task { Context, Goal, Task }
import ceylon.test { assertEquals, test }

Task noopTask = (Context context) => true;

Goal createTestGoal(String name) {
    return Goal(name, noopTask);
}

test void shouldHaveGivenName() {
    assertEquals("MyGoal", createTestGoal("MyGoal").name);
}

test void shouldHoldGivenTask() {
    function myTask(Context context) {
        print("hello");
        return true;
    }
    Goal myGoal = Goal("MyGoal", myTask);
    assertEquals(myTask, myGoal.task);
}

test void shouldHaveNoDependenciesByDefault() {
    Goal myGoal = Goal("MyGoal", noopTask);
    assertEquals([], myGoal.dependencies);
}

test void shouldHoldDependencies() {
    Goal firstDependency = createTestGoal("firstDependency");
    Goal secondDependency = createTestGoal("secondDependency");
    value dependencies = [firstDependency, secondDependency];
    Goal myGoal = Goal("MyGoal", noopTask, dependencies);
    assertEquals(dependencies, myGoal.dependencies);
}