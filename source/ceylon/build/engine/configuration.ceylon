import ceylon.build.task { Goal, Writer }

class ConfigurationCheck(shared Boolean valid, shared Integer exitCode) {}

ConfigurationCheck checkConfiguration({Goal+} goals, Writer writer) {
    ConfigurationCheck configCheck;
    value invalidTasks = invalidGoalsName(goals);
    if (!invalidTasks.empty) {
        writer.error("# invalid goals found ``invalidTasks``");
        writer.error("# goal name should match following format: ```validTaskNamePattern```");
        configCheck = ConfigurationCheck(false, exitCodes.invalidGoalFound);
    } else {
        value duplicateGoals = findDuplicateGoals(goals);
        if (!duplicateGoals.empty) {
            writer.error("# duplicate goal names found: ``duplicateGoals``");
            configCheck = ConfigurationCheck(false, exitCodes.duplicateGoalsFound);
        } else {
            value cycles = analyzeDependencyCycles(goals);
            if (!cycles.empty) {
                writer.error("# goal dependency cycle found between: ``cycles``");
                configCheck = ConfigurationCheck(false, exitCodes.dependencyCycleFound);
            } else {
                configCheck = ConfigurationCheck(true, exitCodes.success);
            }
        }
    }
    return configCheck;
}
