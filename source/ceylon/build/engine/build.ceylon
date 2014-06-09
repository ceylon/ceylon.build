import ceylon.build.task { Writer }

shared EngineResult runEngine(
    "Goals available in the engine"
    GoalDefinitionsBuilder|GoalDefinitions goals,
    "Writer to which info and error messages will be written.
     Default is to output to console."
    Writer writer,
    "Arguments given to the engine (goals names and options).
     Default value is `process.arguments`"
    [String*] arguments = process.arguments) {
    Integer startTime = system.milliseconds;
    if (goals is GoalDefinitionsBuilder) {
        writer.info("## ceylon.build");
    }
    value result = processGoals(goals, arguments, writer);
    Integer endTime = system.milliseconds;
    String duration = "duration ``(endTime - startTime) / 1000``s";
    if (result.status == success) {
        writer.info("## success - ``duration``");
    } else {
        writer.error("## failure - ``duration``");
    }
    return result;
}

EngineResult processGoals(GoalDefinitionsBuilder|GoalDefinitions goals, [String*] arguments, Writer writer) {
    GoalDefinitions definitions;
    switch (goals)
    case (is GoalDefinitionsBuilder) {
        value definitionValidationResult = goals.validate();
        if (!definitionValidationResult.valid) {
            value status = reportInvalidDefinitions(definitionValidationResult, writer);
            return EngineResult(definitionValidationResult.definitions, [], status);
        } else {
            assert(exists defs = definitionValidationResult.definitions);
            definitions = defs;
        }
    } case (is GoalDefinitions) {
        definitions = goals;
    }
    value goalsToRun = buildGoalExecutionList(definitions, arguments, writer).sequence();
    value result = runGoals(goalsToRun, arguments, definitions, writer);
    return EngineResult(definitions, result.executionResults, result.status);
}
