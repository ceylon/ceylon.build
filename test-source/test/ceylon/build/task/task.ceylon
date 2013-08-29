import ceylon.build.task { Task, Context }
import ceylon.test { assertEquals, assertNotEquals }

Task createTestTask(String name) {
    return Task(name, (Context context) => true);
}

void shouldHaveGivenName() {
    assertEquals("MyTask", createTestTask("MyTask").name);
}

void tasksWithSameNamesAreEquals() {
    assertEquals(createTestTask("MyTask1"), createTestTask("MyTask1"));
}

void tasksWithDifferentNamesAreNotEquals() {
    assertNotEquals(createTestTask("MyTask1"), createTestTask("MyTask2"));
}

void tasksWithSameNamesHaveSameHash() {
    assertEquals(createTestTask("MyTask1").hash, createTestTask("MyTask1").hash);
}

void tasksWithDifferentNamesHashHaveDifferentHash() {
    value myTask1Name = "MyTask1";
    value myTask2Name = "MyTask2";
    assertNotEquals(myTask1Name.hash, myTask2Name.hash);
    assertNotEquals(createTestTask(myTask1Name).hash, createTestTask(myTask2Name).hash);
}