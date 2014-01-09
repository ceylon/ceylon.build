import ceylon.test { test, assertEquals }
import ceylon.build.runner { deferredTasks }
import ceylon.build.task { Task }

test void shouldCreateDeferredTasksIterableWithZeroIteration() {
    variable Integer callCounter = 0;
    {Task*} holder() {
        callCounter++;
        return { task1, task2 };
    }
    deferredTasks(holder);
    assertEquals(callCounter, 0);
}

test void shouldCreateDeferredTasksIterableWithOneIteration() {
    variable Integer callCounter = 0;
    {Task*} holder() {
        callCounter++;
        return { task1, task2 };
    }
    value tasks = deferredTasks(holder);
    assertEquals(tasks.sequence, [task1, task2]);
    assertEquals(callCounter, 1);
}

test void shouldCreateDeferredTasksIterableWithTwoIterations() {
    variable Integer callCounter = 0;
    {Task*} holder() {
        callCounter++;
        return { task1, task2 };
    }
    value tasks = deferredTasks(holder);
    assertEquals(tasks.sequence, [task1, task2]);
    assertEquals(tasks.sequence, [task1, task2]);
    assertEquals(callCounter, 1);
}

