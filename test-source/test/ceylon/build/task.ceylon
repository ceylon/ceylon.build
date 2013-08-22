import ceylon.test { assertNotEquals, assertEquals }
import ceylon.build { findDuplicateTasks }

void testTasks() {
    value a = createTestTask("a");
    value b = createTestTask("b");
    value aBis = createTestTask("a");
    assertEquals(a, aBis);
    assertNotEquals(a, b);
    assertNotEquals(b, aBis);
}

void testTasksDefinitions() {
    value a = createTestTask("a");
    value b = createTestTask("b");
    value c = createTestTask("c");
    value d = createTestTask("d");
    assertEquals(LazySet {}, LazySet({}));
    assertEquals(LazySet { a }, LazySet({ a }));
    assertEquals(LazySet { a }, LazySet({ createTestTask("a") }));
    assertEquals(LazySet { a, b }, LazySet({ a, createTestTask("b") }));
    assertEquals(LazySet { a, b }, LazySet({ createTestTask("a"), b }));
    assertEquals(LazySet { a, b }, LazySet({ a, b }));
    assertEquals(LazySet { a, b, c, d }, LazySet({ a, b, createTestTask("c"), createTestTask("d") }));
}

void testDuplicateTasks() {
    assertEquals([], findDuplicateTasks([createTestTask("a"), createTestTask("b"), createTestTask("c")]));
    assertEquals(["b"], findDuplicateTasks([createTestTask("a"), createTestTask("b"), createTestTask("c"), createTestTask("b")]));
    assertEquals(["a", "b"], findDuplicateTasks([createTestTask("a"), createTestTask("b"), createTestTask("b"), createTestTask("a")]));
}