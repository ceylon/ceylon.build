import ceylon.build.task { Goal, Named, Writer, Context, Outcome, done }
import ceylon.collection { LinkedList, MutableList }
import ceylon.test { assertEquals }

Outcome noOp(Context context) => done;

Goal createTestGoal(String name, {Goal*} dependencies = []) {
    return Goal(name, noOp, dependencies);
}

void assertElementsNamesAreEquals({Named*} expected, {Named*} actual) {
    String(Named) name = (Named n) => n.name;
    assertEquals(expected.collect(name), actual.collect(name));
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