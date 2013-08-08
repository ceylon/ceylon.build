import ceylon.build { taskDefinitionMap }
import ceylon.test { assertNotEquals, assertEquals }
import ceylon.collection { HashMap }

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
    assertEquals(HashMap {}, taskDefinitionMap({}));
    assertEquals(HashMap { a -> [] }, taskDefinitionMap({ a }));
    assertEquals(HashMap { a -> [] }, taskDefinitionMap({ a -> [] }));
    assertEquals(HashMap { a -> [], b -> [] }, taskDefinitionMap({ a, b }));
    assertEquals(HashMap { a -> [], b -> [] }, taskDefinitionMap({ a -> [], b -> [] }));
    assertEquals(HashMap { a -> [], b -> [] }, taskDefinitionMap({ a, b -> [] }));
    assertEquals(HashMap { a -> [], b -> [c, d], c -> [], d -> [a] }, taskDefinitionMap({ a, b -> [c, d], c, d -> [a] }));
}
