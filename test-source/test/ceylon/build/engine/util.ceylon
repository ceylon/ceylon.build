import ceylon.build.task { Goal, Writer, Context }
import ceylon.collection { LinkedList, MutableList }

Boolean noOp(Context context) => true;

Goal createTestGoal(String name, {Goal*} dependencies = []) {
    return Goal(name, noOp, dependencies);
}

class MockWriter() satisfies Writer {
    
    MutableList<String> internalInfoMessages = LinkedList<String>();
    
    shared {String*} infoMessages => internalInfoMessages;
    
    MutableList<String> internalErrorMessages = LinkedList<String>();
    
    shared {String*} errorMessages => internalErrorMessages;
    
    shared actual void info(String message) => internalInfoMessages.add(message);
    
    shared actual void error(String message) => internalErrorMessages.add(message);
    
    shared void clear() {
        internalInfoMessages.clear();
        internalErrorMessages.clear();
    }
}