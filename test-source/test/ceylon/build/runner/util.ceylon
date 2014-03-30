import ceylon.build.engine {
    Goal
}
import ceylon.build.runner {
    InvalidGoalDeclaration
}
import ceylon.collection {
    MutableList,
    ArrayList,
    HashMap
}
import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}
import ceylon.test {
    fail,
    assertEquals,
    assertFalse,
    afterTest,
    beforeTest,
    assertTrue
}

Map<FunctionOrValueDeclaration, [FunctionOrValueDeclaration*]> emptyPhases = HashMap();

variable MutableList<String> accumulator = ArrayList<String>(2);

beforeTest afterTest void resetAccumulator() {
    accumulator.clear();
}

final class ExpectedDefinition(name, task = true, dependencies = [], internal = false) {
    shared String name;
    shared Boolean task;
    shared Boolean internal;
    shared [String*] dependencies;
    
    shared actual Integer hash {
        variable Integer hash = 17;
        hash = hash * 31 + name.hash;
        hash = hash * 31 + task.hash;
        hash = hash * 31 + internal.hash;
        hash = hash * 31 + dependencies.hash;
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if (is ExpectedDefinition that) {
            return
                    name == that.name &&
                    task == that.task &&
                    internal == that.internal &&
                    dependencies == that.dependencies;
        }
        return false;
    }
    
    string => "ExpectedDefinition[name:``name``, task:``task``, internal:``internal``, dependencies:``dependencies``]";
}

void checkGoalDefinition(
    Goal|InvalidGoalDeclaration goal,
    ExpectedDefinition expectedDefinition,
    [String*] expectedAccumulatorContent = []) {
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
