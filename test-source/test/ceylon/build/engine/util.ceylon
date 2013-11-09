import ceylon.build.task { Goal, Writer, Context, Outcome, done, GoalSet }
import ceylon.collection { LinkedList, MutableList }
import ceylon.test { assertEquals }
import ceylon.build.engine { runEngine }

Outcome noOp(Context context) => done;

Goal createTestGoal(String name, {Goal*} dependencies = []) {
    return Goal(name, [noOp], dependencies);
}

void assertElementsNamesAreEquals({Goal*} expected, {Goal*} actual) {
    String(Goal) name = (Goal n) => n.name;
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

[String+] names({<Goal|GoalSet>+} goals) {
    value namesList = LinkedList<String>();
    for (goal in goals) {
        switch (goal)
        case (is Goal) {
            namesList.add(goal.name);
        } case (is GoalSet) {
            for (innerGoal in goal.goals) {
                namesList.add(innerGoal.name);
            }
        }
    }
    [String*] names = namesList.sequence;
    assert(nonempty names);
    return names;
}

Integer callEngine({<Goal|GoalSet>+} goals, [String*] arguments = names(goals), Writer writer = MockWriter()) {
    return runEngine(goals, "test project", arguments, writer);
}
