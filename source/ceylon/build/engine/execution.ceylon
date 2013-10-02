import ceylon.build.task { Goal, GoalGroup, Context, Writer }

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
            try {
                if (!goal.task(Context(goalArguments, writer))) {
                    writer.error("# goal ``goal`` failure, stopping");
                    return exitCode.errorOnTaskExecution;
                }
            } catch (Exception exception) {
                writer.error("# error during goal execution ``goal``, stopping");
                writer.exception(exception);
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
