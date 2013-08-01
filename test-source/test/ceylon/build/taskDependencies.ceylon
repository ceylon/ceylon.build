import ceylon.build { analyzeDependencyCycles, Task }
import ceylon.collection { HashMap }
import ceylon.test { assertTrue }

void testDependenciesCycles() {
    shouldNotFoundCycle();
    shouldFoundCycle();
}

void shouldNotFoundCycle() {
    Task a = createTask("a");
    Task b = createTask("b");
    Task c = createTask("c");
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
    Task a = createTask("a");
    Task b = createTask("b");
    Task c = createTask("c");
    assertTrue(!analyzeDependencyCycles(HashMap {
        a -> [b, c],
        b -> [c],
        c -> [a]
    }).empty);
}