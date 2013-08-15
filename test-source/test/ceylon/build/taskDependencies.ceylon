import ceylon.build { analyzeDependencyCycles, Task }
import ceylon.test { assertTrue }
import ceylon.collection { HashSet }

void testDependenciesCycles() {
    shouldNotFoundCycle();
    //shouldFoundCycle();
}

void shouldNotFoundCycle() {
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    Task c = createTestTask("c");
    Task d = createTestTask("d", [c]);
    Task e = createTestTask("e", [b, c]);
    Task f = createTestTask("f", [d]);
    assertTrue(analyzeDependencyCycles(HashSet({})).empty);
    assertTrue(analyzeDependencyCycles(HashSet({})).empty);
    assertTrue(analyzeDependencyCycles(HashSet({ a, c, d })).empty);
    assertTrue(analyzeDependencyCycles(HashSet({ b, c, e })).empty);
    assertTrue(analyzeDependencyCycles(HashSet({ c, d, f })).empty);
    assertTrue(analyzeDependencyCycles(HashSet({ a, b, c, d, e, f })).empty);
}

// TODO not possible since dependencies are declared at task creation.
// TODO And so, it can only refers previously defined task.
// TODO This means that dependency check is done by compiler
// TODO So unless a new way of declaring dependencies is introduce, we should
// TODO remove this dependencies cycle check from the ceylon.build 
//void shouldFoundCycle() {
//    Task a = createTestTask("a");
//    Task b = createTestTask("b", [a]);
//    Task c = createTestTask("c", [b, a]);
//    assertTrue(!analyzeDependencyCycles(HashSet({a, b, c})).empty);
//}