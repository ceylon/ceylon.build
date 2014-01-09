import ceylon.test { test, assertEquals }
import ceylon.build.runner { tasksFromTasksImport, isTasksImport }
import ceylon.build.task { Task, Context, done }
import ceylon.language.meta.model { Value }

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
