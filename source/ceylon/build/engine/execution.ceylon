import ceylon.build.task { Goal, Task, Context, Writer, Outcome, Success, Failure }
import ceylon.collection { LinkedList, MutableList }

String argumentPrefix = "-D";

ExecutionResult runGoals({Goal*} goals, [String*] arguments, {Goal*} availableGoals, Writer writer) {
    value executed = LinkedList<Goal->{Success*}>();
    value failed = LinkedList<Goal->{Outcome*}>();
    if (goals.empty) {
        writer.error("# no goal to run, available goals are: ``goalsNames(availableGoals)``");
        return ExecutionResult(goals.sequence, executed.sequence, failed.sequence, exitCodes.noGoalToRun);
    } else {
        writer.info("# running goals: ``goals`` in order");
        for (goal in goals) {
            value goalArguments = filterArgumentsForGoal(goal, arguments);
            writer.info("# running ``goal.name``(``", ".join(goalArguments)``)");
            value succeed = executeTasks(goal, goalArguments, writer, executed, failed);
            if (!succeed) {
                return ExecutionResult(goals.sequence, executed.sequence, failed.sequence, exitCodes.errorOnTaskExecution);
            }
        }
        return ExecutionResult(goals.sequence, executed.sequence, failed.sequence, exitCodes.success);
    }
}

String goalsNames({Goal*} goals) => "[``", ".join({for (goal in goals) goal.name})``]";

[String*] filterArgumentsForGoal(Goal goal, [String*] arguments) {
    String prefix = "``argumentPrefix````goal.name``:";
    return [for (argument in arguments) if (argument.startsWith(prefix)) argument.spanFrom(prefix.size)];
}

Boolean executeTasks(
    Goal goal,
    [String*] goalArguments,
    Writer writer,
    MutableList<Goal->{Success*}> executed,
    MutableList<Goal->{Outcome*}> failed) {
    value successfullOutcomes = LinkedList<Success>();
    value outcomes = LinkedList<Outcome>();
    for (Task task in goal.tasks) {
        value outcome = executeTask(task, goalArguments, writer);
        outcomes.add(outcome);
        reportOutcome(outcome, goal, writer);
        outcomes.add(outcome);
        switch (outcome)
        case (is Success) {
            successfullOutcomes.add(outcome);
        }
        case (is Failure) {
            failed.add(goal -> outcomes);
            return false;
        }
    }
    executed.add(goal -> successfullOutcomes);
    return true;
}

Outcome executeTask(Task task, [String*] goalArguments, Writer writer) {
    try {
        return task(Context(goalArguments, writer));
    } catch (Exception exception) {
        return Failure("", exception);
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
