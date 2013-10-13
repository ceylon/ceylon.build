import ceylon.file { File, Directory, Nil, Path }
import ceylon.build.tasks.file { copyFiles }

void shouldCopyFileToFile() {
    Path output = initializeTestFolder("shouldCopyFileToFile");
    value source = dataPath("simple-file/file");
    value destination = output.childPath("simple-file");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    copyFiles(source, destination);
    "Destination file should exist"
    assert(destination.resource is File);
}

void shouldCopyFileToFolder() {
    Path output = initializeTestFolder("shouldCopyFileToFolder");
    value source = dataPath("simple-file/file");
    value destinationFolder = output.childPath("folder");
    value destinationResource = destinationFolder.resource;
    assert(is Nil destinationResource);
    destinationResource.createDirectory();
    "Destination folder should exist"
    assert(destinationFolder.resource is Directory);
    value destinationFile = destinationFolder.childPath("file");
    "Destination file shouldn't exist"
    assert(destinationFile.resource is Nil);
    copyFiles(source, destinationFolder);
    "Destination file should exist"
    assert(destinationFile.resource is File);
}

void shouldCopyFileToFileInNonExistingFolder() {
    Path output = initializeTestFolder("shouldCopyFileToFileInNonExistingFolder");
    value source = dataPath("simple-file/file");
    value destination = output.childPath("non-existing-folder/simple-file");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    copyFiles(source, destination);
    "Destination file should exist"
    assert(destination.resource is File);
}

void shouldCopyFolderToFolder() {
    Path output = initializeTestFolder("shouldCopyFolderToFolder");
    value source = dataPath("simple-folder");
    value destination = output.childPath("simple-folder");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    copyFiles(source, destination);
    value destinationResource = destination.resource;
    "Destination file should exist"
    assert(is Directory destinationResource);
    value children = { for (resource in destinationResource.children()) shortname(resource.path) }.sequence;
    "Destination folder should file-a and file-b"
    assert(children == ["file-a", "file-b"]);
}
