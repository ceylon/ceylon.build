import ceylon.build.engine { mergeGoalSetsWithGoals }
import ceylon.build.task { Context, Goal, GoalSet, Task, prefix }
import ceylon.test { assertEquals }

Goal goalA = createTestGoal("a");
Goal goalB = createTestGoal("b");

void testMergeGoalSet() {
    shouldKeepGoals();
    shouldExplodeGoalSetInGoals();
    shouldRenameGoalsInGoalSet();
    shouldKeepGoalTaskWhenRenamingGoal();
    shouldMergeGoalsAndGoalSets();
}

void shouldKeepGoals() {
    assertEquals({ goalA }, mergeGoalSetsWithGoals({ goalA }));
    assertEquals({ goalA, goalB }, mergeGoalSetsWithGoals({ goalA, goalB }));
}
void shouldExplodeGoalSetInGoals() {
    GoalSet goalSetAB = GoalSet({goalA, goalB});
    assertEquals({ goalA, goalB }, mergeGoalSetsWithGoals({ goalSetAB }));
}

void shouldRenameGoalsInGoalSet() {
    GoalSet goalSetABRenamed = GoalSet({goalA, goalB}, prefix("prefix-"));
    assertEquals({ createTestGoal("prefix-a"), createTestGoal("prefix-b") }, mergeGoalSetsWithGoals({ goalSetABRenamed }));
}

void shouldKeepGoalTaskWhenRenamingGoal() {
    variable Integer count = 0;
    Task task = function(Context context) {
        count++;
        return true;
    };
    Goal goal = Goal("goal", task);
    GoalSet goalSet = GoalSet({ goal }, prefix("prefixed-"));
    {Goal+} mergedGoals = mergeGoalSetsWithGoals({ goalSet });
    assertEquals({ Goal("prefixed-goal", task) }, mergedGoals);
    assertEquals(0, count);
    Context context = Context([], MockWriter());
    mergedGoals.first.task(context);
    assertEquals(1, count);
}

void shouldMergeGoalsAndGoalSets() {
    Goal goalC = createTestGoal("c");
    Goal goalD = createTestGoal("d");
    Goal goalE = createTestGoal("e");
    Goal goalF = createTestGoal("f");
    Goal goalG = createTestGoal("g");
    GoalSet goalSetCDE = GoalSet({goalC, goalD, goalE});
    GoalSet goalSetFG = GoalSet({goalF, goalG}, prefix("prefix-"));
    assertEquals {
        expected = { goalA, goalC, goalD, goalE, createTestGoal("prefix-f"), createTestGoal("prefix-g"), goalB };
        actual = mergeGoalSetsWithGoals({ goalA, goalSetCDE, goalSetFG, goalB });
    };
    
}