import ceylon.build { Task, findTasksToExecute, linearize, reduce }
import ceylon.test { assertEquals }
import ceylon.collection { HashMap }

void testTasksOrchestration() {
    testFindTasksToExecute();
    testTasksLinearization();
    testTasksReduction();
}

void testFindTasksToExecute() {
    value writer = MockWriter();
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    assertEquals([], findTasksToExecute(HashMap {
        a -> []
    }, [], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findTasksToExecute(HashMap {
        a -> []
    }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([], findTasksToExecute(HashMap {
        a -> []
    }, ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals(["# task 'b' not found, stopping"], writer.errorMessages);
    writer.clear();
    assertEquals([a, b], findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a", "b"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a, b], findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a", "b", "-Dfoo=bar"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
    writer.clear();
    assertEquals([a], findTasksToExecute(HashMap {
        a -> [b],
        b -> []
    }, ["a"], writer));
    assertEquals([], writer.infoMessages);
    assertEquals([], writer.errorMessages);
}

void testTasksLinearization() {
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    Task c = createTestTask("c");
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
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    Task c = createTestTask("c");
    assertEquals([], reduce([]));
    assertEquals([a], reduce([a]));
    assertEquals([a], reduce([a, a]));
    assertEquals([a, b], reduce([a, b]));
    assertEquals([b, a], reduce([b, a, b]));
    assertEquals([b, a, c], reduce([b, a, b, b, a, c, a, b]));
}