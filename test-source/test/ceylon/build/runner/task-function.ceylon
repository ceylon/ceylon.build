import ceylon.test { test, assertEquals }
import ceylon.build.runner { tasksFromTaskFunction, isTaskFunction }
import ceylon.build.task { Context, Outcome, done, Success, Failure }
import ceylon.language.meta.model { Function }

variable Integer tasksFromTaskFunctionCallCounter = 0;
Outcome taskFunction(Context context) {
    tasksFromTaskFunctionCallCounter++;
    return done;
}

test void shouldEmbedTaskFunctionInTasks() {
    tasksFromTaskFunctionCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromTaskFunction(`taskFunction`).sequence);
    assertEquals(tasksFromTaskFunctionCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromTaskFunctionCallCounter, 1);
}

class TestTaskMethod() {
    shared variable Integer callCounter = 0;
    
    shared Outcome attribute(Context context) {
        callCounter++;
        return done;
    }
}

test void shouldEmbedTaskMethodInTasks() {
    value context = mockContext();
    value obj = TestTaskMethod();
    assert(nonempty tasks = tasksFromTaskFunction(`TestTaskMethod.attribute`.bind(obj)).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}

Outcome taskFunction0(Context context) => done;
Success taskFunction1(Context context) => done;
Failure taskFunction2(Context context) => Failure();
Anything taskFunction3(Context context) => done;
Anything taskFunction4() => 1;
Outcome taskFunction5() => done;
Outcome taskFunction6(Context context, Object obj) => done;

test void shouldRecognizeTaskFunction() {
    for (func in {`taskFunction0`, `taskFunction1`, `taskFunction2`}) {
        assertRecognizeTaskFunction(func, true);
    }
}

test void shouldNotRecognizeTaskFunction() {
    value functions = {
        `taskFunction3`,
        `taskFunction4`,
        `taskFunction5`,
        `taskFunction6`
    };
    for (func in functions) {
        assertRecognizeTaskFunction(func, false);
    }
}

void assertRecognizeTaskFunction(Function<Anything, Nothing> model, Boolean expected) {
    value actual = isTaskFunction(model);
    assertEquals(actual, expected,
    "isTaskFunction(``model.declaration.name``) failed: expected ``expected`` but was ``actual``");
}
