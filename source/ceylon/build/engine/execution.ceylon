import ceylon.build.task { Goal, Writer, Outcome, Failure, done }

String argumentPrefix = "-D";

ExecutionResult runGoals([String*] goals, [String*] arguments, GoalDefinitions definitions, Writer writer) {
    value results = SequenceBuilder<GoalExecutionResult>();
    if (goals.empty) {
        writer.error("# no goal to run, available goals are: ``definitions.availableGoals``");
        return ExecutionResult([], noGoalToRun);
    } else {
        Status status;
        writer.info("# running goals: ``goals`` in order");
        for (goal in goals) {
            value goalArguments = filterArgumentsForGoal(goal, arguments);
            writer.info("# running ``goal``(``", ".join(goalArguments)``)");
            value result = executeTasks(goal, definitions, goalArguments, writer);
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

String goalsNames({Goal*} goals) => "[``", ".join({for (goal in goals) goal.name})``]";

[String*] filterArgumentsForGoal(String goal, [String*] arguments) {
    String prefix = "``argumentPrefix````goal``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)];
}

GoalExecutionResult executeTasks(String goal, GoalDefinitions definitions, String[] arguments, Writer writer) {
    value properties = definitions.properties(goal);
    value outcome = executeTask(properties.task, arguments, writer);
    reportOutcome(outcome, goal, writer);
    return GoalExecutionResult(goal, arguments, outcome);
}

Outcome executeTask(Anything() task, [String*] goalArguments, Writer writer) {
    try {
        // TODO set context: context = Context(goalArguments, writer)
        task();
        return done;
    } catch (Exception exception) {
        return Failure("", exception);
    }
}

void reportOutcome(Outcome outcome, String goal, Writer writer) {
    if (is Failure outcome) {
        writer.error("# goal ``goal`` failure, stopping");
        value message = outcome.message;
        if (!message.empty) {
            writer.error(message);
        }
        value exception = outcome.exception;
        // TODO there will always be an exception but if it's a TaskException, do not log the stack
        if (exists exception) { 
            writer.exception(exception);
        }
    }
}

GoalExecutionResult[] notRunGoalsExecutionResult({String*} notRunGoals, String[] arguments) {
    return [ for (notRun in notRunGoals)
        GoalExecutionResult(notRun, filterArgumentsForGoal(notRun, arguments), null)
    ];
}
