import ceylon.test { assertNotEquals, assertEquals }

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
