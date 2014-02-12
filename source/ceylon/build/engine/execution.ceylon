import ceylon.build.task {
    Writer,
    setContextForTask,
    clearTaskContext
}

String argumentPrefix = "-D";

ExecutionResult runGoals([String*] goals, [String*] arguments, GoalDefinitions definitions, Writer writer) {
    value results = SequenceBuilder<GoalExecutionResult>();
    if (goals.empty) {
        if (definitions.availableGoals.empty) {
            writer.error("# no available goals");
            if (!definitions.internalGoals.empty) {
                writer.error("# following internal goals exist: ``displayGoalsList(definitions.internalGoals)``");
                writer.error("# did you forgot to make them shared?");
            }
        } else {
            writer.error("# no goal to run, available goals are: ``displayGoalsList(definitions.availableGoals)``");
        }
        return ExecutionResult([], noGoalToRun);
    } else {
        Status status;
        writer.info("# running goals: ``goals`` in order");
        for (goal in goals) {
            value goalArguments = filterArgumentsForGoal(goal, arguments);
            writer.info("# running ``goal``(``", ".join(goalArguments)``)");
            value result = executeGoal(goal, definitions, goalArguments, writer);
            results.append(result);
            if (!result.success) {
                status = errorOnTaskExecution;
                results.appendAll(notRunGoalsExecutionResult(goals.skipping(results.size), arguments));
                break;
            }
        } else {
            status = success;
        }
        return ExecutionResult(results.sequence, status);
    }
}

String displayGoalsList([String*] goals) => "[``", ".join(goals)``]";

[String*] filterArgumentsForGoal(String goal, [String*] arguments) {
    String prefix = "``argumentPrefix````goal``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)];
}

GoalExecutionResult executeGoal(String goal, GoalDefinitions definitions, String[] arguments, Writer writer) {
    value properties = definitions.properties(goal);
    "Goal with noop leaked into execution list"
    assert (exists task = properties.task);
    value outcome = executeTask(task, arguments, writer);
    reportOutcome(outcome, goal, writer);
    return GoalExecutionResult(goal, arguments, outcome);
}

Outcome executeTask(Anything() task, [String*] arguments, Writer writer) {
    variable Outcome outcome;
    setContextForTask(arguments, writer);
    try {
        task();
        outcome = ok;
    } catch (Exception exception) {
        outcome = Failure(exception);
    }
    clearTaskContext();
    return outcome;
}

void reportOutcome(Outcome outcome, String goal, Writer writer) {
    if (is Failure outcome) {
        writer.error("# goal ``goal`` failure, stopping");
        value exception = outcome.exception;
        // TODO there will always be an exception but if it's a TaskException, do not log the stack
        writer.exception(exception);
    }
}

GoalExecutionResult[] notRunGoalsExecutionResult({String*} notRunGoals, String[] arguments) {
    return [ for (notRun in notRunGoals)
        GoalExecutionResult(notRun, filterArgumentsForGoal(notRun, arguments), null)
    ];
}
