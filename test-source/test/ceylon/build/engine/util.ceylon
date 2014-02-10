import ceylon.build.task { Writer }
import ceylon.collection { LinkedList, MutableList }
import ceylon.build.engine { runEngine, EngineResult, GoalDefinitionsBuilder, Goal, GoalProperties }

void emptyFunction() {}

Goal createTestGoal(String name, [String*] dependencies = [], Anything() fn = emptyFunction, Boolean internal = false) {
    return Goal(name, GoalProperties(internal, fn, dependencies));
}

class MockWriter() satisfies Writer {
    
    MutableList<String> internalInfoMessages = LinkedList<String>();
    
    shared {String*} infoMessages => internalInfoMessages;
    
    MutableList<String> internalErrorMessages = LinkedList<String>();
    
    shared {String*} errorMessages => internalErrorMessages;
    
    shared actual void info(String message) => internalInfoMessages.add(message);
    
    shared actual void error(String message) => internalErrorMessages.add(message);
}

[String*] definitionsNames(EngineResult result) {
    if (exists definitions = result.definitions) {
        return definitions.availableGoals;
    }
    return [];
}

[String*] names({<Goal>*} goals) {
    return [ for (goal in goals) goal.name ];
}

EngineResult callEngine(GoalDefinitionsBuilder builder, [String*] arguments, Writer writer = MockWriter()) {
    return runEngine(builder, writer, arguments);
}

[String*] execution(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) result.goal];
}

[String*] succeed(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) if (result.success) result.goal];
}

[String*] failed(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) if (result.failed) result.goal];
}

[String*] notRun(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) if (result.notRun) result.goal];
}

GoalDefinitionsBuilder builderFromGoals({Goal*} availableGoals) {
    value builder = GoalDefinitionsBuilder();
    for (goal in availableGoals) {
        builder.add(goal);
    }
    return builder;
}
