import ceylon.test { beforeTest, afterTest }
import ceylon.build.tasks.file { delete, createDirectory }
import ceylon.file { parsePath, Path, Nil }
import ceylon.build.task { Writer, setContextForTask, clearTaskContext }
import ceylon.build.tasks.ant { renewAntProject }

Path baseWorkingPath = parsePath("tmp/test/ceylon/build/tasks/ant");

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
    createDirectory(baseWorkingResource);
    // set base directory for Ant
    renewAntProject(baseWorkingPath.string);
}

afterTest void resetContext() {
    clearTaskContext();
}
