import ceylon.build { analyzeDependencyCycles, Task }
import ceylon.collection { HashMap }
import ceylon.test { assertTrue }

Task createTask(String taskName) {
    object task satisfies Task {
        shared actual String name = taskName;
        shared actual void process(String[] arguments) {}
    }
    return task;
}
Task a = createTask("a");
Task b = createTask("b");
Task c = createTask("c");
    
void testDependenciesCycles() {
    shouldNotFoundCycle();
    shouldFoundCycle();
}

void shouldNotFoundCycle() {
    assertTrue(analyzeDependencyCycles(HashMap {}).empty);
    assertTrue(analyzeDependencyCycles(HashMap {
        a -> [],
        b -> [],
        c -> []
    }).empty);
    assertTrue(analyzeDependencyCycles(HashMap {
        a -> [b],
        b -> [],
        c -> []
    }).empty);
    assertTrue(analyzeDependencyCycles(HashMap {
        a -> [b,c],
        b -> [],
        c -> []
    }).empty);
    assertTrue(analyzeDependencyCycles(HashMap {
        a -> [b],
        b -> [c],
        c -> []
    }).empty);
    assertTrue(analyzeDependencyCycles(HashMap {
        a -> [b, c],
        b -> [c],
        c -> []
    }).empty);
    
    
}

void shouldFoundCycle() {
    assertTrue(!analyzeDependencyCycles(HashMap {
        a -> [b, c],
        b -> [c],
        c -> [a]
    }).empty);
}