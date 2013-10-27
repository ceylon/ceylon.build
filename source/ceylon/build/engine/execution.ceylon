import ceylon.build.task { Goal, GoalGroup, Task, Context, Writer, Outcome, Success, Failure, failed }

String argumentPrefix = "-D";

shared Integer runGoals({Goal*} goals, String[] arguments, {<Goal|GoalGroup>*} availableGoals, Writer writer) {
    if (goals.empty) {
        writer.error("# no goal to run, available goals are: ``goalsNames(availableGoals)``");
        return exitCode.noGoalToRun;
    } else {
        writer.info("# running goals: ``goals`` in order");
        for (goal in goals) {
            value goalArguments = filterArgumentsForGoal(goal, arguments);
            writer.info("# running ``goal.name``(``", ".join(goalArguments)``)");
            value outcome = executeTask(goal.task, goalArguments, writer);
            reportOutcome(outcome, goal, writer);
            if (is Failure outcome) {
                return exitCode.errorOnTaskExecution;
            }
        }
        return exitCode.success;
    }
}

String goalsNames({<Goal|GoalGroup>*} goals) => "[``", ".join({for (goal in goals) goal.name})``]";

shared String[] filterArgumentsForGoal(Goal goal, String[] arguments) {
    String prefix = "``argumentPrefix````goal.name``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)];
}

Outcome executeTask(Task task, [String*] goalArguments, Writer writer) {
    try {
        return task(Context(goalArguments, writer));
    } catch (Exception exception) {
        return failed {
            exception = exception;
        };
    }
}

void reportOutcome(Outcome outcome, Goal goal, Writer writer) {
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
