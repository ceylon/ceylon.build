
"Execution result"
class ExecutionResult(executionResults,  exitCode) {
    
    "Goals execution results (ordered according to goal execution)"
    shared [GoalExecutionResult*] executionResults;
    
    "Exit code"
    see(`value exitCodes`)
    shared Integer exitCode;
}
