import ceylon.build.task { Context, Goal, Task }
import ceylon.test { assertEquals }

Task noopTask = (Context context) => true;

Goal createTestGoal(String name) {
    return Goal(name, noopTask);
}

void shouldHaveGivenName() {
    assertEquals("MyGoal", createTestGoal("MyGoal").name);
}

void shouldHoldGivenTask() {
    Task myTask = function(Context context) {
        print("hello");
        return true;
    };
    Goal myGoal = Goal("MyGoal", myTask);
    assertEquals(myTask, myGoal.task);
}

void shouldHaveNoDependenciesByDefault() {
    Goal myGoal = Goal("MyGoal", noopTask);
    assertEquals([], myGoal.dependencies);
}

void shouldHoldDependencies() {
    Goal firstDependency = createTestGoal("firstDependency");
    Goal secondDependency = createTestGoal("secondDependency");
    value dependencies = [firstDependency, secondDependency];
    Goal myGoal = Goal("MyGoal", noopTask, dependencies);
    assertEquals(dependencies, myGoal.dependencies);
}