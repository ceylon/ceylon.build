import ceylon.build { Task, linearize, reduce }
import ceylon.test { assertEquals }
import ceylon.collection { HashMap }

void testTasksOrchestration() {
    testTasksLinearization();
    testTasksReduction();
}

void testTasksLinearization() {
    Task a = createTask("a");
    Task b = createTask("b");
    Task c = createTask("c");
    assertEquals([a], linearize(a, HashMap {
        a -> []
    }));
    assertEquals([b, a], linearize(a, HashMap {
        a -> [b],
        b -> []
    }));
    assertEquals([c, b, a], linearize(a, HashMap {
        a -> [b],
        b -> [c],
        c -> []
    }));
    assertEquals([c, b, c, a], linearize(a, HashMap {
        a -> [b, c],
        b -> [c],
        c -> []
    }));
}

void testTasksReduction() {
    Task a = createTask("a");
    Task b = createTask("b");
    Task c = createTask("c");
    assertEquals([], reduce([]));
    assertEquals([a], reduce([a]));
    assertEquals([a], reduce([a, a]));
    assertEquals([a, b], reduce([a, b]));
    assertEquals([b, a], reduce([b, a, b]));
    assertEquals([b, a, c], reduce([b, a, b, b, a, c, a, b]));
}