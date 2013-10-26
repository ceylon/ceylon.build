import ceylon.build.task { Goal, GoalGroup, Named }
import ceylon.test { assertEquals, test }

GoalGroup createTestGoalGroup(String name) {
    return GoalGroup(name, [createTestGoal("a"), createTestGoal("b")]);
}

test void goalGroupShouldHaveGivenName() {
    assertEquals("MyGoalGroup", createTestGoalGroup("MyGoalGroup").name);
}

test void shouldHoldGoalsAndGoalGroups() {
    Goal myGoal1 = createTestGoal("1");
    Goal myGoal2 = createTestGoal("2");
    assertElementsNamesAreEquals([myGoal1], GoalGroup("MyGoalGroup", [myGoal1]).goals);
    assertElementsNamesAreEquals([myGoal1, myGoal2], GoalGroup("MyGoalGroup", [myGoal1, myGoal2]).goals);
}

void assertElementsNamesAreEquals({Named*} expected, {Named*} actual) {
    String(Named) name = (Named n) => n.name;
    assertEquals(expected.collect(name), actual.collect(name));
}