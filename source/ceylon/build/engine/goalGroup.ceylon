import ceylon.build.task { GoalGroup, Goal }
import ceylon.collection { MutableList, LinkedList }

{Goal*} goalsList({<Goal|GoalGroup>*} goalsAndGroups) {
    MutableList<Goal> goals = LinkedList<Goal>();
    for (goalOrGroup in goalsAndGroups) {
        switch (goalOrGroup)
        case (is Goal) {
            goals.add(goalOrGroup);
        } case (is GoalGroup) {
            goals.addAll(goalsList(goalOrGroup.goals));
        }
    }
    return goals;
}
