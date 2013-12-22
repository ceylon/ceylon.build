import ceylon.test { beforeTest }
import ceylon.build.tasks.file { deletePath, createDirectory }
import ceylon.file { parsePath, Path, Nil }

Path baseDataPath = parsePath("test-source/test/ceylon/build/tasks/file/data");
Path baseWorkingPath = parsePath("tmp/test/ceylon/build/tasks/file");

beforeTest void cleanTestDirectory() {
    deletePath(baseWorkingPath);
    value baseWorkingResource = baseWorkingPath.resource;
    "Test directory already exists"
    assert(is Nil baseWorkingResource);
    createDirectory(baseWorkingPath.resource);
}
