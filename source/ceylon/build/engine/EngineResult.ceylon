import ceylon.build.task { Goal }

"This class holds information about goals execution (success / failures) for a given engine execution"
shared class EngineResult(availableGoals, executionResults, exitCode) {
    
    "Goals available in the engine"
    shared [Goal*] availableGoals;
    
    "Goals execution results (ordered according to goal execution)"
    shared [GoalExecutionResult*] executionResults;
    
    "Exit code"
    see(`value exitCodes`)
    shared Integer exitCode;
}
