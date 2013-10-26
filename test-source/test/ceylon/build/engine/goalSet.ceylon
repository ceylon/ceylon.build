import ceylon.build.engine { mergeGoalSetsWithGoals }
import ceylon.build.task { Goal, GoalSet }
import ceylon.test { test }

Goal goalA = createTestGoal("a");
Goal goalB = createTestGoal("b");

test void shouldKeepGoals() {
    assertElementsNamesAreEquals({ goalA }, mergeGoalSetsWithGoals({ goalA }));
    assertElementsNamesAreEquals({ goalA, goalB }, mergeGoalSetsWithGoals({ goalA, goalB }));
}
test void shouldExplodeGoalSetInGoals() {
    GoalSet goalSetAB = GoalSet({goalA, goalB});
    assertElementsNamesAreEquals({ goalA, goalB }, mergeGoalSetsWithGoals({ goalSetAB }));
}

test void shouldMergeGoalsAndGoalSets() {
    Goal goalC = createTestGoal("c");
    Goal goalD = createTestGoal("d");
    Goal goalE = createTestGoal("e");
    Goal goalF = createTestGoal("f");
    Goal goalG = createTestGoal("g");
    GoalSet goalSetCDE = GoalSet({goalC, goalD, goalE});
    GoalSet goalSetFG = GoalSet({goalF, goalG});
    assertElementsNamesAreEquals {
        expected = { goalA, goalC, goalD, goalE, goalF, goalG, goalB };
        actual = mergeGoalSetsWithGoals({ goalA, goalSetCDE, goalSetFG, goalB });
    };
    
}
