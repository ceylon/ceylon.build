import ceylon.build.task { Goal, Context }
import ceylon.test { assertEquals, assertNotEquals }

Goal createTestGoal(String name) {
    return Goal(name, (Context context) => true);
}

void shouldHaveGivenName() {
    assertEquals("MyGoal", createTestGoal("MyGoal").name);
}

void goalsWithSameNamesAreEquals() {
    assertEquals(createTestGoal("MyGoal1"), createTestGoal("MyGoal1"));
}

void goalsWithDifferentNamesAreNotEquals() {
    assertNotEquals(createTestGoal("MyGoal1"), createTestGoal("MyGoal2"));
}

void goalsWithSameNamesHaveSameHash() {
    assertEquals(createTestGoal("MyGoal1").hash, createTestGoal("MyGoal1").hash);
}

void goalsWithDifferentNamesHashHaveDifferentHash() {
    value myGoal1Name = "MyGoal1";
    value myGoal2Name = "MyGoal2";
    assertNotEquals(myGoal1Name.hash, myGoal2Name.hash);
    assertNotEquals(createTestGoal(myGoal1Name).hash, createTestGoal(myGoal2Name).hash);
}