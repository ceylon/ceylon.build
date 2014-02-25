import ceylon.build.task { Writer }
import ceylon.collection { LinkedList, MutableList }
import ceylon.build.engine { EngineResult, Goal, GoalProperties, Status, successStatus = success }
import ceylon.test { assertEquals, assertTrue }

void emptyFunction() {}

Goal createTestGoal(String name, [String*] dependencies = [], Anything()? fn = emptyFunction, Boolean internal = false) {
    return Goal(name, GoalProperties(internal, fn, dependencies));
}

class MockWriter() satisfies Writer {
    
    MutableList<String> internalInfoMessages = LinkedList<String>();
    
    shared [String*] infoMessages => internalInfoMessages.sequence;
    
    MutableList<String> internalErrorMessages = LinkedList<String>();
    
    shared [String*] errorMessages => internalErrorMessages.sequence;
    
    MutableList<Exception> internalWrittenExceptions = LinkedList<Exception>();
    
    shared [Exception*] writtenExceptions => internalWrittenExceptions.sequence;
    
    shared actual void info(String message) => internalInfoMessages.add(message);
    
    shared actual void error(String message) => internalErrorMessages.add(message);
    
    shared actual void exception(Exception exception) {
        error(exception.message);
        internalWrittenExceptions.add(exception);
    }
}

[String*] names({<Goal>*} goals) {
    return [ for (goal in goals) goal.name ];
}

void checkExecutionResult(
    EngineResult result,
    Status status,
    [String*] available,
    [String*] toRun,
    [String*] successful,
    [String*] failed,
    [String*] notRun,
    MockWriter writer,
    [String*] infoMessages,
    [String*] errorMessages) {
    
    [String*] definitionsNames(EngineResult result) {
        if (exists definitions = result.definitions) {
            return definitions.availableGoals;
        }
        return [];
    }
    
    [String*] executionList(EngineResult engineResult) {
        return [for (result in engineResult.executionResults) result.goal];
    }
    
    [String*] success(EngineResult engineResult) {
        return [for (result in engineResult.executionResults) if (result.success) result.goal];
    }
    
    [String*] failure(EngineResult engineResult) {
        return [for (result in engineResult.executionResults) if (result.failed) result.goal];
    }
    
    [String*] notExecuted(EngineResult engineResult) {
        return [for (result in engineResult.executionResults) if (result.notRun) result.goal];
    }
    
    assertEquals(result.status, status);
    assertEquals(definitionsNames(result), available);
    assertEquals(executionList(result), toRun);
    assertEquals(success(result), successful);
    assertEquals(failure(result), failed);
    assertEquals(notExecuted(result), notRun);
    assertEquals(notExecuted(result), notRun);
    assertEquals(notExecuted(result), notRun);
    if (result.status == successStatus) {
        assertEquals(writer.infoMessages[0..writer.infoMessages.size-2], infoMessages);
        assertTrue((writer.infoMessages.last else "").startsWith("## success"));
        assertEquals(writer.infoMessages.size, infoMessages.size + 1);
        assertEquals(writer.errorMessages, errorMessages);
    } else {
        assertEquals(writer.infoMessages, infoMessages);
        assertEquals(writer.errorMessages[0..writer.errorMessages.size-2], errorMessages);
        assertTrue((writer.errorMessages.last else "").startsWith("## failure"));
        assertEquals(writer.errorMessages.size, errorMessages.size + 1);
    }
}
