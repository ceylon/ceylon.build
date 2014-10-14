import ceylon.build.task {
    Writer,
    setContextForTask,
    clearTaskContext
}
import ceylon.build.tasks.ant {
    AntProject
}
import ceylon.build.tasks.file {
    delete,
    createDirectory
}
import ceylon.file {
    parsePath,
    Path,
    Nil
}
import ceylon.test {
    beforeTest,
    afterTest
}

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
}

afterTest void resetContext() {
    clearTaskContext();
}

AntProject createAntProjectWithBaseDirectorySet() {
    AntProject antProject = AntProject();
    antProject.effectiveBaseDirectory(baseWorkingPath.string);
    return antProject;
}
