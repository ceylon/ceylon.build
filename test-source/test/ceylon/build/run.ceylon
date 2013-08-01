import ceylon.build { analyzeDependencyCycles, Task }
import ceylon.collection { HashMap }

"Run the module `test.ceylon.build`."
void run() {
    testDependenciesCycles();
    print("tests succeed");
}

void testDependenciesCycles() {
    shouldNotFoundCycle();
}

void shouldNotFoundCycle() {
    value a = createTask("a");
    value b = createTask("b");
    value c = createTask("c");
    assert (analyzeDependencyCycles(HashMap {}).empty);
    assert (analyzeDependencyCycles(HashMap {
        a -> [],
        b -> [],
        c -> []
    }).empty);
    assert (analyzeDependencyCycles(HashMap {
        a -> [b],
        b -> [],
        c -> []
    }).empty);
    assert (analyzeDependencyCycles(HashMap {
        a -> [b,c],
        b -> [],
        c -> []
    }).empty);
    assert (analyzeDependencyCycles(HashMap {
        a -> [b],
        b -> [c],
        c -> []
    }).empty);
    assert (analyzeDependencyCycles(HashMap {
        a -> [b, c],
        b -> [c],
        c -> []
    }).empty);
    assert (!analyzeDependencyCycles(HashMap {
        a -> [b, c],
        b -> [c],
        c -> [a]
    }).empty);
    
}

Task createTask(String taskName) {
    object task satisfies Task {
        shared actual String name = taskName;
        shared actual void process(String[] arguments) {}
    }
    return task;
}