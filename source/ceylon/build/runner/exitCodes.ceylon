
"List of program exit code"
object exitCodes {
    "Success exit code as per standard conventions"
    shared Integer success = 0;
    
    "Exit code returned when an invalid `Goal` is found
     
     This can happen if a goal name contains forbidden characters"
    shared Integer invalidGoalFound = 1;
    
    "Exit code returned when multiples `Goal` have the same name"
    shared Integer duplicateGoalsFound = 2;
    
    "Exit code returned when a dependency cycle has been found"
    shared Integer dependencyCycleFound = 3;
    
    "Exit code returned when there is no goal to be run.
     
     This happens because no goal has been requested or because the requested goal doesn't exists."
    shared Integer noGoalToRun = 4;
    
    "Exit code returned when a goal's task failed"
    shared Integer errorOnTaskExecution = 5;
}
