import ceylon.build.task { Writer }

shared Status reportInvalidDefinitions(DefinitionsValidationResult validationResult, Writer writer) {
    Status status;
    if (validationResult.hasInvalidNames) {
        writer.error("# invalid goals found ``validationResult.invalidNames``");
        writer.error("# goal name should match following format: `[a-z][a-zA-Z0-9-.]*`");
        status = invalidGoalFound;
    } else if (validationResult.hasDuplicatedDefinitions) {
        writer.error("# duplicate goal names found: ``validationResult.duplicated``");
        status = duplicateGoalsFound;
    } else if (validationResult.hasUndefinedDefinitions) {
        writer.error("# undefined goal referenced from dependency: ``validationResult.undefined``");
        status = undefinedGoalsFound;
    } else if (validationResult.hasDependencyCycles) {
        writer.error("# goal dependency cycle found between: ``validationResult.dependencyCycles``");
        status = dependencyCycleFound;
    } else {
        throw Exception("!!Bug!! missing valid / invalid configuration check");
    }
    return status;
}
