import ceylon.test { suite }
import ceylon.build.tasks.file { deletePath, createDirectory }
import ceylon.file { parsePath, Path, Nil }

Path baseDataPath = parsePath("test-source/test/ceylon/build/tasks/file/data");
Path baseWorkingPath = parsePath("tmp/test/ceylon/build/tasks/file");

void cleanTestFolder() {
    deletePath(baseWorkingPath);
    value baseWorkingResource = baseWorkingPath.resource;
    "Test folder already exists"
    assert(is Nil baseWorkingResource);
    createDirectory(baseWorkingPath.resource);
}

"Run the module `test.ceylon.build.tasks.file`."
shared void run() {
    cleanTestFolder();
    suite("ceylon.build.tasks.file",
    "shouldCopyFileToFile" -> shouldCopyFileToFile,
    "shouldCopyFileToFolder" -> shouldCopyFileToFolder,
    "shouldCopyFileToFileInNonExistingFolder" -> shouldCopyFileToFileInNonExistingFolder,
    "shouldCopyFolderToFolder" -> shouldCopyFolderToFolder);
}
