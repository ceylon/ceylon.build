
"This class holds information about goals execution (success / failures) for a given engine execution"
shared class EngineResult(definitions, executionResults, status) {
    
    "Goals definitions"
    shared GoalDefinitions? definitions;
    
    "Goals execution results (ordered according to goal execution)"
    shared [GoalExecutionResult*] executionResults;
    
    "execution status"
    see(`interface Status`)
    shared Status status;
}
