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
            goalsList.addAll(item.goals);
        }
    }
    value goalsSequence = goalsList.sequence;
    assert(nonempty goalsSequence);
    return goalsSequence;
}
