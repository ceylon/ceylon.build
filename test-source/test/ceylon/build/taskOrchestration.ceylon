import ceylon.build { Task, Builder }
import ceylon.test { assertEquals }
import ceylon.collection { HashMap }

void printToNull(String message) {}

void testTasksOrchestration() {
    testFindTasksToExecute();
    testTasksLinearization();
    testTasksReduction();
}

void testFindTasksToExecute() {
    Task a = createTask("a");
    Task b = createTask("b");
    assertEquals([], Builder(printToNull).findTasksToExecute(HashMap {
        a -> []
    }, []));
    assertEquals([a], Builder(printToNull).findTasksToExecute(HashMap {
        a -> []
    }, ["a"]));
    assertEquals([], Builder(printToNull).findTasksToExecute(HashMap {
        a -> []
    }, ["a", "b"]));
    assertEquals([a, b], Builder(printToNull).findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a", "b"]));
    assertEquals([a, b], Builder(printToNull).findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a", "b", "-Dfoo=bar"]));
    assertEquals([a], Builder(printToNull).findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a"]));
    assertEquals([a], Builder(printToNull).findTasksToExecute(HashMap {
        a -> [b],
        b -> []
    }, ["a"]));
}

void testTasksLinearization() {
    Task a = createTask("a");
    Task b = createTask("b");
    Task c = createTask("c");
    assertEquals([a], Builder().linearize(a, HashMap {
        a -> []
    }));
    assertEquals([b, a], Builder().linearize(a, HashMap {
        a -> [b],
        b -> []
    }));
    assertEquals([c, b, a], Builder().linearize(a, HashMap {
        a -> [b],
        b -> [c],
        c -> []
    }));
    assertEquals([c, b, c, a], Builder().linearize(a, HashMap {
        a -> [b, c],
        b -> [c],
        c -> []
    }));
}

void testTasksReduction() {
    Task a = createTask("a");
    Task b = createTask("b");
    Task c = createTask("c");
    assertEquals([], Builder().reduce([]));
    assertEquals([a], Builder().reduce([a]));
    assertEquals([a], Builder().reduce([a, a]));
    assertEquals([a, b], Builder().reduce([a, b]));
    assertEquals([b, a], Builder().reduce([b, a, b]));
    assertEquals([b, a, c], Builder().reduce([b, a, b, b, a, c, a, b]));
}