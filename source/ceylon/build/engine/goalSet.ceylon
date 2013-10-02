import ceylon.build.task { Goal, GoalGroup, GoalSet }
import ceylon.collection { LinkedList }

shared {<Goal|GoalGroup>+} mergeGoalSetsWithGoals({<Goal|GoalGroup|GoalSet>+} goals) {
    value goalsList = LinkedList<Goal|GoalGroup>();
    for (item in goals) {
        switch (item)
        case (is Goal|GoalGroup){
            goalsList.add(item);
        }
        case (is GoalSet){
            {Goal+} setGoals = [ for (goal in item.goals) renameGoal(item.rename, goal) ];
            goalsList.addAll(setGoals);
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