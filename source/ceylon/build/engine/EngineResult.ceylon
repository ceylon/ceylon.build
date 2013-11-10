import ceylon.build.task { Outcome, Success, Goal }

"This class holds information about goals execution (success / failures) for a given engine execution"
shared class EngineResult(availableGoals, executionList, executed, failed, notRun, exitCode) {
    
    "Goals available in the engine"
    shared [Goal*] availableGoals;
    
    "Goals execution list representing the list of goals that should have be executed.
     
     This list could differ from `executed` if some goal execution failed"
    shared [Goal*] executionList;
    
    "Goals that have been successfully executed"
    shared [<Goal->{Success*}>*] executed;
    
    "Goals that failed to execute
     
     Note that if a goal has multiple tasks and the first ones succeed
     but not a later one, then, it will be in `failed`.
     It will not appear in `executed` nor in `notRun`"
    shared [<Goal->{Outcome*}>*] failed;
    
    "Goals from the execution list that have not been executed
     because a previous goal in the execution list failed"
    shared [Goal*] notRun;
    
    "Exit code"
    see(`value exitCodes`)
    shared Integer exitCode;
}

"Execution result"
class ExecutionResult(toExecute, executed, failed, exitCode) {
    
    "List of goals that should be executed"
    shared [Goal*] toExecute;
    
    "Goals that have been successfully executed"
    shared [<Goal->{Success*}>*] executed;
    
    "Goals that failed to execute.
     
     Note that if a goal has multiple tasks and the first ones succeed
     but not a later one, then, it will be in `failed`.
     It will not appear in `executed` nor in `notRun`"
    shared [<Goal->{Outcome*}>*] failed;
    
    "Goals that have not been executed because a previous goal in the execution list failed"
    shared [Goal*] notRun = !failed.empty then toExecute.sequence.spanFrom(executed.size + failed.size) else [];
    
    "Exit code"
    see(`value exitCodes`)
    shared Integer exitCode;
}
