import ceylon.build.task { Outcome, Goal, Failure }

"Represents a goal execution status result"
shared class GoalExecutionResult(goal, arguments, outcomes) {
    
    "Goal itself"
    shared Goal goal;
    
    "Arguments being passed to the goal for execution"
    shared [String*] arguments;
    
    "Outcomes of tasks execution.
     
     If a task has not been run because of a previous task failure, its `Outcome` won't be present.
     This means that goals that have not been run at all will have an empty outcomes list"
    shared {Outcome*} outcomes;
    
    Boolean hasFailure() {
        value nbFailedOutcome = outcomes.count((Outcome element) {
            if (is Failure element) {
                return true;
            } else {
                return false;
            }
        });
        return nbFailedOutcome > 0;
    }
    
    "`true` if the goal has not been run (no tasks of the goal has been run)"
    shared Boolean notRun = outcomes.empty;
    
    "`true` if the goal has been run and all of its tasks succeed"
    shared Boolean success = !notRun && !hasFailure();
    
    "`true` if the goal has been run and one of its tasks failed"
    shared Boolean failed = !notRun && hasFailure();
}
