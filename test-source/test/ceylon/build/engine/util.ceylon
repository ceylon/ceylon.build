import ceylon.build.task { Goal, GoalSet, Writer, Context, Outcome, done }
import ceylon.collection { LinkedList, MutableList }
import ceylon.build.engine { runEngine, EngineResult }

Outcome noOp(Context context) => done;

Goal createTestGoal(String name, {Goal*} dependencies = []) {
    return Goal(name, [noOp], dependencies);
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

[String*] names({<Goal|GoalSet|<Goal->{Outcome*}>>*} goals) {
    value namesList = SequenceBuilder<String>();
    for (goal in goals) {
        switch (goal)
        case (is Goal) {
            namesList.append(goal.name);
        } case (is GoalSet) {
            for (innerGoal in goal.goals) {
                namesList.append(innerGoal.name);
            }
        } case (is Goal->{Outcome*}) {
            namesList.append(goal.key.name);
        }
    }
    [String*] names = namesList.sequence;
    return names;
}

EngineResult callEngine({<Goal|GoalSet>+} goals, [String*] arguments = names(goals), Writer writer = MockWriter()) {
    return runEngine(goals, "test project", arguments, writer);
}

[String*] execution(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) result.goal];
}

[String*] success(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) if (result.success) result.goal];
}

[String*] failed(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) if (result.failed) result.goal];
}

[String*] notRun(EngineResult engineResult) {
    return [for (result in engineResult.executionResults) if (result.notRun) result.goal];
}
