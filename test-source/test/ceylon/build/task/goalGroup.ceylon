import ceylon.build.task { Goal, GoalGroup }
import ceylon.test { assertEquals, assertNotEquals }

GoalGroup createTestGoalGroup(String name) {
    return GoalGroup(name, [createTestGoal("a"), createTestGoal("b")]);
}

void goalGroupShouldHaveGivenName() {
    assertEquals("MyGoalGroup", createTestGoalGroup("MyGoalGroup").name);
}

void goalGroupsWithSameNamesAreEquals() {
    assertEquals(createTestGoalGroup("MyGoalGroup1"), createTestGoalGroup("MyGoalGroup1"));
}

void goalGroupsWithDifferentNamesAreNotEquals() {
    assertNotEquals(createTestGoalGroup("MyGoalGroup1"), createTestGoalGroup("MyGoalGroup2"));
}

void goalGroupsWithSameNamesHaveSameHash() {
    assertEquals(createTestGoalGroup("MyGoalGroup1").hash, createTestGoalGroup("MyGoalGroup1").hash);
}

void goalGroupsWithDifferentNamesHashHaveDifferentHash() {
    value myGoalGroup1Name = "MyGoalGroup1";
    value myGoalGroup2Name = "MyGoalGroup2";
    assertNotEquals(myGoalGroup1Name.hash, myGoalGroup2Name.hash);
    assertNotEquals(createTestGoalGroup(myGoalGroup1Name).hash, createTestGoalGroup(myGoalGroup2Name).hash);
}

void shouldHoldGoals() {
    Goal myGoal1 = createTestGoal("1");
    Goal myGoal2 = createTestGoal("2");
    assertEquals([myGoal1], GoalGroup("MyGoalGroup", [myGoal1]).goals);
    assertEquals([myGoal1, myGoal2], GoalGroup("MyGoalGroup", [myGoal1, myGoal2]).goals);
}