
"Execution result"
class ExecutionResult(executionResults, status) {
    
    "Goals execution results (ordered according to goal execution)"
    shared [GoalExecutionResult*] executionResults;
    
    "Exit code"
    see(`interface Status`)
    shared Status status;
}
