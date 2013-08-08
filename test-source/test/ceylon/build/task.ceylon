import ceylon.build { Task }
import ceylon.test { assertNotEquals, assertEquals }

void testTasks() {
    Task a = createTestTask("a");
    Task b = createTestTask("b");
    Task aBis = createTestTask("a");
    assertEquals(a, aBis);
    assertNotEquals(a, b);
    assertNotEquals(b, aBis);
}