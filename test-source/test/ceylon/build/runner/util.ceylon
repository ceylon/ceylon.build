import ceylon.build.engine { Goal }
import ceylon.test { fail, assertEquals, assertFalse, afterTest, beforeTest, assertTrue }
import ceylon.build.runner { InvalidGoalDeclaration }
import ceylon.collection { MutableList, ArrayList }

variable MutableList<String> accumulator = ArrayList<String>(2);

beforeTest afterTest void resetAccumulator() {
    accumulator.clear();
}

class ExpectedDefinition(name, task = true, dependencies = [], internal = false) {
    shared String name;
    shared Boolean task;
    shared Boolean internal;
    shared [String*] dependencies;
}

void checkGoalDefinition(
    Goal|InvalidGoalDeclaration goal,
    ExpectedDefinition expectedDefinition,
    [String*] expectedAccumulatorContent) {
    assert(is Goal goal);
    assertEquals(goal.name, expectedDefinition.name);
    assertEquals(goal.properties.internal, expectedDefinition.internal);
    assertEquals(goal.properties.dependencies, expectedDefinition.dependencies);
    if (expectedDefinition.task) {
        if (exists task = goal.properties.task) {
            task();
        } else {
            fail("Task function was expected but not found");
        }
    } else {
        assertFalse(goal.properties.task exists);
    }
    assertEquals(accumulator.sequence, expectedAccumulatorContent);
}

void checkInvalidGoalDefinition(Goal|InvalidGoalDeclaration invalid) {
    assertTrue(invalid is InvalidGoalDeclaration);
}
