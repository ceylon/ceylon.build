import ceylon.test { test, assertEquals }
import ceylon.build.runner { deferredTasks, tasksFromFunction, tasksFromTaskFunction, isVoidWithNoParametersFunction, isTaskFunction, tasksFromTasksDelegate, tasksFromTaskDelegate, isTaskDelegateFunction, isTasksDelegateFunction }
import ceylon.build.task { Task, Context, Writer, Outcome, done, Success, Failure }
import ceylon.language.meta.declaration { OpenClassOrInterfaceType, FunctionDeclaration }

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
    assert(nonempty tasks = tasksFromFunction(`function voidFunction`, null).sequence);
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
    assert(nonempty tasks = tasksFromFunction(`function TestVoidMethod.method`, obj).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}

variable Integer tasksFromTaskFunctionCallCounter = 0;
Outcome taskFunction(Context context) {
    tasksFromTaskFunctionCallCounter++;
    return done;
}

test void shouldEmbedTaskFunctionInTasks() {
    tasksFromTaskFunctionCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromTaskFunction(`function taskFunction`, null).sequence);
    assertEquals(tasksFromTaskFunctionCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromTaskFunctionCallCounter, 1);
}

class TestTaskMethod() {
    shared variable Integer callCounter = 0;
    
    shared Outcome method(Context context) {
        callCounter++;
        return done;
    }
}

test void shouldEmbedTaskMethodInTasks() {
    value context = mockContext();
    value obj = TestTaskMethod();
    assert(nonempty tasks = tasksFromTaskFunction(`function TestTaskMethod.method`, obj).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}

variable Integer tasksFromTaskDelegateCallCounter = 0;
Task taskDelegateFunction() => function(Context context) {
    tasksFromTaskDelegateCallCounter++;
    return done;
};

test void shouldReturnTaskDelegateFunctionTasks() {
    tasksFromTaskDelegateCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromTaskDelegate(`function taskDelegateFunction`, null).sequence);
    assertEquals(tasksFromTaskDelegateCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromTaskDelegateCallCounter, 1);
}

class TestTaskDelegateMethod() {
    shared variable Integer callCounter = 0;
    
    shared Task method() => function(Context context) {
        callCounter++;
        return done;
    };
    
    shared Anything notATaskDelegate() { throw; }
}

test void shouldReturnTaskDelegateMethodTasks() {
    value context = mockContext();
    value obj = TestTaskDelegateMethod();
    assert(nonempty tasks = tasksFromTaskDelegate(`function TestTaskDelegateMethod.method`, obj).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}


variable Integer tasksFromTasksDelegateCallCounter = 0;
{Task*} tasksDelegateFunction() => {
        function(Context context) {
        tasksFromTasksDelegateCallCounter++;
        return done;
    },
    function(Context context) {
        tasksFromTasksDelegateCallCounter++;
        return done;
    }
};

test void shouldReturnTasksDelegateFunctionTasks() {
    tasksFromTasksDelegateCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromTasksDelegate(`function tasksDelegateFunction`, null).sequence);
    assertEquals(tasksFromTasksDelegateCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromTasksDelegateCallCounter, 1);
    assert(exists second = tasks.get(1));
    second(context);
    assertEquals(tasksFromTasksDelegateCallCounter, 2);
}

class TestTasksDelegateMethod() {
    shared variable Integer callCounter = 0;
    
    shared {Task*} method() => {
        function(Context context) {
            callCounter++;
            return done;
        },
        function(Context context) {
            callCounter++;
            return done;
        }
    };
    
    shared Anything notATasksDelegate() { throw; }
}

test void shouldReturnTasksDelegateMethodTasks() {
    value context = mockContext();
    value obj = TestTasksDelegateMethod();
    assert(nonempty tasks = tasksFromTasksDelegate(`function TestTasksDelegateMethod.method`, obj).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
    assert(exists second = tasks.get(1));
    second(context);
    assertEquals(obj.callCounter, 2);
    
}

test void shouldCreateDeferredTasksIterableWithZeroIteration() {
    variable Integer callCounter = 0;
    {Task*} holder() {
        callCounter++;
        return { task1, task2 };
    }
    deferredTasks(holder);
    assertEquals(callCounter, 0);
}

test void shouldCreateDeferredTasksIterableWithOneIteration() {
    variable Integer callCounter = 0;
    {Task*} holder() {
        callCounter++;
        return { task1, task2 };
    }
    value tasks = deferredTasks(holder);
    assertEquals(tasks.sequence, [task1, task2]);
    assertEquals(callCounter, 1);
}

test void shouldCreateDeferredTasksIterableWithTwoIterations() {
    variable Integer callCounter = 0;
    {Task*} holder() {
        callCounter++;
        return { task1, task2 };
    }
    value tasks = deferredTasks(holder);
    assertEquals(tasks.sequence, [task1, task2]);
    assertEquals(tasks.sequence, [task1, task2]);
    assertEquals(callCounter, 1);
}

void voidWithNoParametersFunction1() {}
void voidWithParametersFunction(Context context) {}
Outcome outcomeWithNoParametersFunction() => done;
Outcome outcomeWithParametersFunction(Context context) => done;

test void shouldRecognizeVoidWithNoParametersFunction() {
    assertRecognizeVoidWithNoParametersFunction(`function voidWithNoParametersFunction1`, true);
}

test void shouldNotRecognizeVoidWithNoParametersFunction() {
    assertRecognizeVoidWithNoParametersFunction(`function voidWithParametersFunction`, false);
    assertRecognizeVoidWithNoParametersFunction(`function outcomeWithNoParametersFunction`, false);
    assertRecognizeVoidWithNoParametersFunction(`function outcomeWithParametersFunction`, false);
}

void assertRecognizeVoidWithNoParametersFunction(FunctionDeclaration declaration, Boolean expected) {
    assert(is OpenClassOrInterfaceType openType = declaration.openType);
    assertEquals(isVoidWithNoParametersFunction(declaration, openType), expected);
}

Outcome taskFunction0(Context context) => done;
Success taskFunction1(Context context) => done;
Failure taskFunction2(Context context) => Failure();
Anything taskFunction3(Context context) => done;
Anything taskFunction4() => 1;
Outcome taskFunction5() => done;
Outcome taskFunction6(Context context, Object obj) => done;

test void shouldRecognizeTaskFunction() {
    for (func in {`function taskFunction0`, `function taskFunction1`, `function taskFunction2`}) {
        assertRecognizeTaskFunction(func, true);
    }
}

test void shouldNotRecognizeTaskFunction() {
    value functions = {
        `function taskFunction3`,
        `function taskFunction4`,
        `function taskFunction5`,
        `function taskFunction6`
    };
    for (func in functions) {
        assertRecognizeTaskFunction(func, false);
    }
}

void assertRecognizeTaskFunction(FunctionDeclaration declaration, Boolean expected) {
    assert(is OpenClassOrInterfaceType openType = declaration.openType);
    value actual = isTaskFunction(declaration, openType);
    assertEquals(actual, expected,
        "isTaskFunction(``declaration.name``) failed: expected ``expected`` but was ``actual``");
}

Task taskDelegate0() { throw; }
Outcome(Context) taskDelegate1() { throw; }
Success(Context) taskDelegate2() { throw; }
Failure(Context) taskDelegate3() { throw; }
{Task*} tasksDelegate() { throw; }

test void shouldRecognizeTaskDelegateFunction() {
    value declarations = {
        `function taskDelegate0`,
        `function taskDelegate1`
        //,
        //`function taskDelegate2`,
        //`function taskDelegate3`
    };
    for (declaration in declarations) {
        assertRecognizeTaskDelegate(declaration, true);
    }
}

test void shouldRecognizeTaskDelegateMethod() {
    assertRecognizeTaskDelegate(`function TestTaskDelegateMethod.method`, true);
}

test void shouldNotRecognizeTaskDelegateFunction() {
    value declarations = {
        `function tasksDelegate`,
        `function taskFunction0`,
        `function taskFunction1`,
        `function taskFunction2`,
        `function taskFunction3`,
        `function taskFunction4`,
        `function taskFunction5`,
        `function taskFunction6`
    };
    for (declaration in declarations) {
        assertRecognizeTaskDelegate(declaration, false);
    }
}

test void shouldNotRecognizeTaskDelegateMethod() {
    assertRecognizeTaskDelegate(`function TestTaskDelegateMethod.notATaskDelegate`, false);
}

void assertRecognizeTaskDelegate(FunctionDeclaration declaration, Boolean expected) {
    value actual = isTaskDelegateFunction(declaration);
    assertEquals(actual, expected,
        "isTaskDelegateFunction(``declaration.name``) failed: expected ``expected`` but was ``actual``");
}

test void shouldRecognizeTasksDelegateFunction() {
    assertRecognizeTasksDelegate(`function tasksDelegate`, true);
}

test void shouldRecognizeTasksDelegateMethod() {
    assertRecognizeTasksDelegate(`function TestTasksDelegateMethod.method`, true);
}

test void shouldNotRecognizeTasksDelegateFunction() {
    value declarations = {
        `function taskDelegate0`,
        `function taskDelegate1`,
        `function taskDelegate2`,
        `function taskDelegate3`,
        `function taskFunction0`,
        `function taskFunction1`,
        `function taskFunction2`,
        `function taskFunction3`,
        `function taskFunction4`,
        `function taskFunction5`,
        `function taskFunction6`
    };
    for (declaration in declarations) {
        assertRecognizeTasksDelegate(declaration, false);
    }
}

test void shouldNotRecognizeTasksDelegateMethod() {
    assertRecognizeTasksDelegate(`function TestTasksDelegateMethod.notATasksDelegate`, false);
}

void assertRecognizeTasksDelegate(FunctionDeclaration declaration, Boolean expected) {
    value actual = isTasksDelegateFunction(declaration);
    assertEquals(actual, expected,
    "isTasksDelegateFunction(``declaration.name``) failed: expected ``expected`` but was ``actual``");
}
