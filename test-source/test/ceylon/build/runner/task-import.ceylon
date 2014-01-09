import ceylon.test { test, assertEquals }
import ceylon.build.runner { tasksFromTaskImport, isTaskImport }
import ceylon.build.task { Task, Context, Outcome, done, Success, Failure }
import ceylon.language.meta.model { Value }

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
