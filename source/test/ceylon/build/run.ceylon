import ceylon.build { analyzeDependencyCycles, Dependency, Task }
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
    assert (analyzeDependencyCycles([]).empty);
    assert (analyzeDependencyCycles({
        Dependency(a),
        Dependency(b),
        Dependency(c)
    }).empty);
    assert (analyzeDependencyCycles({
        Dependency(a, [b]),
        Dependency(b),
        Dependency(c)
    }).empty);
    assert (analyzeDependencyCycles({
        Dependency(a, [b, c]),
        Dependency(b),
        Dependency(c)
    }).empty);
    assert (analyzeDependencyCycles({
        Dependency(a, [b]),
        Dependency(b, [c]),
        Dependency(c)
    }).empty);
    assert (analyzeDependencyCycles({
        Dependency(a, [b, c]),
        Dependency(b, [c]),
        Dependency(c)
    }).empty);
    assert (!analyzeDependencyCycles({
        Dependency(a, [b, c]),
        Dependency(b, [c]),
        Dependency(c, [a])
    }).empty);
    
}

Task createTask(String taskName) {
    object task satisfies Task {
        shared actual String name = taskName;
        shared actual void process() {}
    }
    return task;
}