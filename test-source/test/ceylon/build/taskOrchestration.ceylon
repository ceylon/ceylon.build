import ceylon.build { Task, Writer, findTasksToExecute, linearize, reduce }
import ceylon.test { assertEquals }
import ceylon.collection { HashMap }

object nullWriter satisfies Writer {
    shared actual void info(String message) {}
    shared actual void error(String message) {}
}

void testTasksOrchestration() {
    testFindTasksToExecute();
    testTasksLinearization();
    testTasksReduction();
}

void testFindTasksToExecute() {
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    assertEquals([], findTasksToExecute(HashMap {
        a -> []
    }, [], nullWriter));
    assertEquals([a], findTasksToExecute(HashMap {
        a -> []
    }, ["a"], nullWriter));
    assertEquals([], findTasksToExecute(HashMap {
        a -> []
    }, ["a", "b"], nullWriter));
    assertEquals([a, b], findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a", "b"], nullWriter));
    assertEquals([a, b], findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a", "b", "-Dfoo=bar"], nullWriter));
    assertEquals([a], findTasksToExecute(HashMap {
        a -> [],
        b -> []
    }, ["a"], nullWriter));
    assertEquals([a], findTasksToExecute(HashMap {
        a -> [b],
        b -> []
    }, ["a"], nullWriter));
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