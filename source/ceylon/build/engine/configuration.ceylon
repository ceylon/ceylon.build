import ceylon.build.task { Writer }

shared Integer reportInvalidDefinitions(DefinitionsValidationResult validationResult, Writer writer) {
    Integer exitCode;
    if (validationResult.hasInvalidNames) {
        writer.error("# invalid goals found ``validationResult.invalidNames``");
        writer.error("# goal name should match following format: ```validTaskNamePattern```");
        exitCode = exitCodes.invalidGoalFound;
    }
    else if (validationResult.hasDuplicatedDefinitions) {
        writer.error("# duplicate goal names found: ``validationResult.duplicated``");
        exitCode = exitCodes.duplicateGoalsFound;
    }
    else if (validationResult.hasDependencyCycles) {
        writer.error("# goal dependency cycle found between: ``validationResult.dependencyCycles``");
        exitCode = exitCodes.dependencyCycleFound;
    } else {
        throw Exception("!!Bug!! missing valid / invalid configuration check");
    }
    return exitCode;
}
