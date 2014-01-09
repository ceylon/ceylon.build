import ceylon.test { test, assertEquals }
import ceylon.build.runner { tasksFromFunction, isVoidWithNoParametersFunction }
import ceylon.build.task { Task, Context, Writer, Outcome, done }
import ceylon.language.meta.model { Function }

Task task1 = function(Context context) { throw; };
Task task2 = function(Context context) { throw; };

Context mockContext() {
    object writer satisfies Writer {
        shared actual void error(String message) {}
        
        shared actual void info(String message) {}
    }
    return Context([], writer);
}

variable Integer tasksFromFunctionCallCounter = 0;
void voidFunction() => tasksFromFunctionCallCounter++;

test void shouldEmbedFunctionInTasks() {
    tasksFromFunctionCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromFunction(`voidFunction`).sequence);
    assertEquals(tasksFromFunctionCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromFunctionCallCounter, 1);
}

class TestVoidMethod() {
    shared variable Integer callCounter = 0;
    
    shared void method() => callCounter++;
}

test void shouldEmbedcallCounterMethodInTasks() {
    value context = mockContext();
    value obj = TestVoidMethod();
    assert(nonempty tasks = tasksFromFunction(`TestVoidMethod.method`.bind(obj)).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}

void voidWithNoParametersFunction1() {}
void voidWithParametersFunction(Context context) {}
Outcome outcomeWithNoParametersFunction() => done;
Outcome outcomeWithParametersFunction(Context context) => done;

test void shouldRecognizeVoidWithNoParametersFunction() {
    assertRecognizeVoidWithNoParametersFunction(`voidWithNoParametersFunction1`, true);
}

test void shouldNotRecognizeVoidWithNoParametersFunction() {
    assertRecognizeVoidWithNoParametersFunction(`voidWithParametersFunction`, false);
    assertRecognizeVoidWithNoParametersFunction(`outcomeWithNoParametersFunction`, false);
    assertRecognizeVoidWithNoParametersFunction(`outcomeWithParametersFunction`, false);
}

void assertRecognizeVoidWithNoParametersFunction(Function<Anything, Nothing> model, Boolean expected) {
    assertEquals(isVoidWithNoParametersFunction(model), expected);
}
