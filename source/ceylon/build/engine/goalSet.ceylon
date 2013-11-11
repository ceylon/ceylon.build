import ceylon.build.task { Goal, GoalSet }
import ceylon.collection { LinkedList }

{Goal+} mergeGoalSetsWithGoals({<Goal|GoalSet>+} goals) {
    value goalsList = LinkedList<Goal>();
    for (item in goals) {
        switch (item)
        case (is Goal){
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
