import ceylon.test { beforeTest, afterTest }
import ceylon.build.tasks.file { delete, createDirectory }
import ceylon.file { parsePath, Path, Nil }
import ceylon.build.task { Writer, setContextForTask, clearTaskContext }

Path baseDataPath = parsePath("test-source/test/ceylon/build/tasks/file/data");
Path baseWorkingPath = parsePath("tmp/test/ceylon/build/tasks/file");

beforeTest void cleanTestDirectory() {
    object writer satisfies Writer {
        shared actual void error(String message) {}
        
        shared actual void info(String message) {}
    }
    setContextForTask([], writer);
    delete(baseWorkingPath);
    value baseWorkingResource = baseWorkingPath.resource;
    "Test directory already exists"
    assert(is Nil baseWorkingResource);
    createDirectory(baseWorkingPath.resource);
}

afterTest void resetContext() {
    clearTaskContext();
}
