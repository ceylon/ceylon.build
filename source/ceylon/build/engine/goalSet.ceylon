import ceylon.build.task { Goal, GoalSet }
import ceylon.collection { LinkedList }

shared {Goal+} mergeGoalSetsWithGoals({<Goal|GoalSet>+} goals) {
    value goalsList = LinkedList<Goal>();
    for (item in goals) {
        if (is GoalSet item) {
            {Goal+} setGoals = [ for (goal in item.goals) renameGoal(item.rename, goal) ];
            goalsList.addAll(setGoals);
        } else if (is Goal item) {
            goalsList.add(item);
        }
    }
    value goalsSequence = goalsList.sequence;
    assert(nonempty goalsSequence);
    return goalsSequence;
}

Goal renameGoal(String(String) newName, Goal goal) {
    "GoalSet with dependencies are not yet supported"
    assert (goal.dependencies.empty);
    return Goal(newName(goal.name), goal.task);
}