import ceylon.build.task { Goal, Task, Context, Writer, Outcome, Success, Failure }
import ceylon.collection { LinkedList }

String argumentPrefix = "-D";

ExecutionResult runGoals([String*] goals, [String*] arguments, GoalDefinitions definitions, Writer writer) {
    value results = SequenceBuilder<GoalExecutionResult>();
    if (goals.empty) {
        writer.error("# no goal to run, available goals are: ``definitions.availableGoals``");
        return ExecutionResult([], exitCodes.noGoalToRun);
    } else {
        Integer exitCode;
        writer.info("# running goals: ``goals`` in order");
        for (goal in goals) {
            value goalArguments = filterArgumentsForGoal(goal, arguments);
            writer.info("# running ``goal``(``", ".join(goalArguments)``)");
            value result = executeTasks(goal, definitions, goalArguments, writer);
            results.append(result);
            if (!result.success) {
                exitCode = exitCodes.errorOnTaskExecution;
                results.appendAll(notRunGoalsExecutionResult(goals.skipping(results.size), arguments));
                break;
            }
        } else {
            exitCode = exitCodes.success;
        }
        return ExecutionResult(results.sequence, exitCode);
    }
}

String goalsNames({Goal*} goals) => "[``", ".join({for (goal in goals) goal.name})``]";

[String*] filterArgumentsForGoal(String goal, [String*] arguments) {
    String prefix = "``argumentPrefix````goal``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)];
}

GoalExecutionResult executeTasks(String goal, GoalDefinitions definitions, String[] arguments, Writer writer) {
    value outcomes = LinkedList<Outcome>();
    value properties = definitions.properties(goal);
    for (Task task in properties.tasks) {
        value outcome = executeTask(task, arguments, writer);
        outcomes.add(outcome);
        reportOutcome(outcome, goal, writer);
        outcomes.add(outcome);
        if (is Failure outcome) {
            break;
        }
    }
    return GoalExecutionResult(goal, arguments, outcomes.sequence);
}

Outcome executeTask(Task task, [String*] goalArguments, Writer writer) {
    try {
        return task(Context(goalArguments, writer));
    } catch (Exception exception) {
        return Failure("", exception);
    }
}

void reportOutcome(Outcome outcome, String goal, Writer writer) {
    if (is Success outcome) {
        if (!outcome.message.empty) {
            writer.info("``outcome.message``");
        }
    } else if (is Failure outcome) {
        writer.error("# goal ``goal`` failure, stopping");
        value message = outcome.message;
        if (!message.empty) {
            writer.error(message);
        }
        value exception = outcome.exception;
        if (exists exception) {
            writer.exception(exception);
        }
    }
}

GoalExecutionResult[] notRunGoalsExecutionResult({String*} notRunGoals, String[] arguments) {
    return [ for (notRun in notRunGoals) GoalExecutionResult(notRun, filterArgumentsForGoal(notRun, arguments), [])];
}
