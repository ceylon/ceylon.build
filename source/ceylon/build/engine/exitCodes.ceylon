
"Represents the engine execution status"
shared interface Status of success | ExecutionFailure {}

"Status returned when execution succeed"
shared object success satisfies Status {}

"Status returned when execution failed"
shared interface ExecutionFailure of
        invalidGoalFound | duplicateGoalsFound | undefinedGoalsFound |
        dependencyCycleFound | noGoalToRun | errorOnTaskExecution
        satisfies Status {}

"Status returned when an invalid `Goal` is found
 
 This can happen if a goal name contains forbidden characters"
shared object invalidGoalFound satisfies ExecutionFailure {}

"Status returned when multiples `Goal` have the same name"
shared object duplicateGoalsFound satisfies ExecutionFailure {}

"Status returned when undefined `Goal` are referenced by dependencies"
shared object undefinedGoalsFound satisfies ExecutionFailure {}

"Status returned when a dependency cycle has been found"
shared object dependencyCycleFound satisfies ExecutionFailure {}

"Status returned when there is no goal to be run.
 
 This happens because no goal has been requested or because the requested goal doesn't exists."
shared object noGoalToRun satisfies ExecutionFailure {}

"Status returned when a goal's task failed"
shared object errorOnTaskExecution satisfies ExecutionFailure {}
