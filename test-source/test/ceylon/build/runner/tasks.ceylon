import ceylon.test { test, assertEquals }
import ceylon.build.runner { deferredTasks, tasksFromFunction, tasksFromTaskFunction, isVoidWithNoParametersFunction, isTaskFunction, tasksFromTasksImport, tasksFromTaskImport, isTaskImport, isTasksImport }
import ceylon.build.task { Task, Context, Writer, Outcome, done, Success, Failure }
import ceylon.language.meta.declaration { OpenClassOrInterfaceType, FunctionDeclaration }
import ceylon.language.meta.model { Value }

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
    
    shared Outcome attribute(Context context) {
        callCounter++;
        return done;
    }
}

test void shouldEmbedTaskMethodInTasks() {
    value context = mockContext();
    value obj = TestTaskMethod();
    assert(nonempty tasks = tasksFromTaskFunction(`function TestTaskMethod.attribute`, obj).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}

variable Integer tasksFromTaskImportCallCounter = 0;
Task taskImport = function(Context context) {
    tasksFromTaskImportCallCounter++;
    return done;
};

test void shouldReturnTaskImportTopLevelAttributeTasks() {
    tasksFromTaskImportCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromTaskImport(`taskImport`).sequence);
    assertEquals(tasksFromTaskImportCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromTaskImportCallCounter, 1);
}

class TestTaskImportClass() {
    shared variable Integer callCounter = 0;
    
    shared Task taskImport = function(Context context) {
        callCounter++;
        return done;
    };
    
    shared Anything notATaskImport { throw; }
}

test void shouldReturnTaskImportAttributeTasks() {
    value context = mockContext();
    value obj = TestTaskImportClass();
    assert(nonempty tasks = tasksFromTaskImport(`TestTaskImportClass.taskImport`.bind(obj)).sequence);
    assertEquals(obj.callCounter, 0);
    tasks.first(context);
    assertEquals(obj.callCounter, 1);
}


variable Integer tasksFromTasksImportCallCounter = 0;
{Task*} tasksImport => {
        function(Context context) {
        tasksFromTasksImportCallCounter++;
        return done;
    },
    function(Context context) {
        tasksFromTasksImportCallCounter++;
        return done;
    }
};

test void shouldReturnTasksImportTopLevelAttributeTasks() {
    tasksFromTasksImportCallCounter = 0;
    value context = mockContext();
    assert(nonempty tasks = tasksFromTasksImport(`tasksImport`).sequence);
    assertEquals(tasksFromTasksImportCallCounter, 0);
    tasks.first(context);
    assertEquals(tasksFromTasksImportCallCounter, 1);
    assert(exists second = tasks.get(1));
    second(context);
    assertEquals(tasksFromTasksImportCallCounter, 2);
}

class TestTasksImportMethod() {
    shared variable Integer callCounter = 0;
    
    shared {Task*} tasksImport => {
        function(Context context) {
            callCounter++;
            return done;
        },
        function(Context context) {
            callCounter++;
            return done;
        }
    };
    
    shared Anything notATasksImport { throw; }
}

test void shouldReturnTasksImportAttributeTasks() {
    value context = mockContext();
    value obj = TestTasksImportMethod();
    assert(nonempty tasks = tasksFromTasksImport(`TestTasksImportMethod.tasksImport`.bind(obj)).sequence);
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

Task taskImport0 { throw; }
Outcome(Context) taskImport1 { throw; }
Success(Context) taskImport2 { throw; }
Failure(Context) taskImport3 { throw; }

test void shouldRecognizeTaskImportTopLevelAttribute() {
    value attributes = {
        `taskImport0`,
        `taskImport1`,
        `taskImport2`,
        `taskImport3`
    };
    for (attribute in attributes) {
        assertRecognizeTaskImport(attribute, true);
    }
}

test void shouldRecognizeTaskImportAttribute() {
    assertRecognizeTaskImport(`TestTaskImportClass.taskImport`.bind(TestTaskImportClass()), true);
}

test void shouldNotRecognizeTaskImportTopLevelAttribute() {
    value attributes = {
        `tasksImport`
    };
    for (attribute in attributes) {
        assertRecognizeTaskImport(attribute, false);
    }
}

test void shouldNotRecognizeTaskImportClassAttribute() {
    assertRecognizeTaskImport(
        `TestTaskImportClass.notATaskImport`.bind(TestTaskImportClass()), false);
}

void assertRecognizeTaskImport(Value<Anything, Nothing> model, Boolean expected) {
    value actual = isTaskImport(model);
    assertEquals(actual, expected,
        "isTaskImport(``model.declaration.name``) failed: expected ``expected`` but was ``actual``");
}

test void shouldRecognizeTasksImportTopLevelAttribute() {
    assertRecognizeTasksImport(`tasksImport`, true);
}

test void shouldRecognizeTasksImportAttribute() {
    assertRecognizeTasksImport(`TestTasksImportMethod.tasksImport`.bind(TestTasksImportMethod()), true);
}

test void shouldNotRecognizeTasksImportTopLevelAttribute() {
    value attributes = {
        `taskImport0`,
        `taskImport1`,
        `taskImport2`,
        `taskImport3`
    };
    for (attribute in attributes) {
        assertRecognizeTasksImport(attribute, false);
    }
}

test void shouldNotRecognizeTasksImportAttribute() {
    assertRecognizeTasksImport(
        `TestTasksImportMethod.notATasksImport`.bind(TestTasksImportMethod()),
        false);
}

void assertRecognizeTasksImport(Value<Anything, Nothing> model, Boolean expected) {
    value actual = isTasksImport(model);
    assertEquals(actual, expected,
    "isTasksImport(``model.declaration.name``) failed: expected ``expected`` but was ``actual``");
}
