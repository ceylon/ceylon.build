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
            {<Goal|GoalGroup>+} setGoals = [ for (goal in item.goals) renameGoal(item.rename, goal) ];
            goalsList.addAll(setGoals);
        }
    }
    value goalsSequence = goalsList.sequence;
    assert(nonempty goalsSequence);
    return goalsSequence;
}

Goal|GoalGroup renameGoal(String(String) rename, Goal|GoalGroup goalOrGroup) {
    value newName = rename(goalOrGroup.name);
    switch (goalOrGroup)
    case (is Goal) {
        "GoalSet with dependencies are not yet supported"
        assert (goalOrGroup.dependencies.empty);
        return Goal(newName, goalOrGroup.task);
    }
    case (is GoalGroup) {
        return GoalGroup(newName, goalOrGroup.goals);
    }
}
