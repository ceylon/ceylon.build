import ceylon.file { File, Directory, Nil, Path, Visitor }
import ceylon.build.tasks.file { copyFiles, extensions, FileFilter }
import ceylon.collection { LinkedList }

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
    createDirectoryFromPath(destinationFolder);
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
    createDirectoryFromPath(destination);
    copyFiles(source, destination);
    value destinationResource = destination.resource;
    "Destination file should exist"
    assert(is Directory destinationResource);
    value children = { for (resource in destinationResource.children()) shortname(resource.path) }.sequence;
    "Destination folder should file-a and file-b"
    assert(children == ["file-a", "file-b"]);
}

void shouldCopyFolderToNonExistingFolder() {
    Path output = initializeTestFolder("shouldCopyFolderToNonExistingFolder");
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

void shouldCopyTree() {
    Path output = initializeTestFolder("shouldCopyTree");
    value source = dataPath("tree");
    value destination = output.childPath("tree");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    FileFilter filter = function(File file) {
        value extensionFilter = extensions("txt", "car", "css", "js", "html", "ext");
        return extensionFilter(file) || file.name.equals("index");
    };
    copyFiles(source, destination, true, filter);
    value destinationResource = destination.resource;
    "Destination file should exist"
    assert(is Directory destinationResource);
    value res = LinkedList<String>();
    object visitor extends Visitor() {
        shared actual Boolean beforeDirectory(Directory directory) {
            res.add(directory.path.relativePath(destination).string);
            return true;
        }
        
        shared actual void file(File file) {
            res.add(file.path.relativePath(destination).string);
        }
    }
    destination.visit(visitor);
    value resources = res.sequence;
    "Destination folder should contain copied files and folders"
    assert(resources == [
        "",
        "a",
        "a/a",
        "a/a/a",
        "a/a/a/file1.txt",
        "a/a/a/file2.ext",
        "a/a/b",
        "a/a/b/file.txt",
        "a/a/c",
        "a/a/c/file.txt",
        "a/b",
        "a/b/a",
        "a/b/a/file.txt",
        "b",
        "b/a",
        "b/a/a",
        "b/a/a/file.css",
        "b/a/b",
        "b/a/b/file.js",
        "b/b",
        "b/b/index.html",
        "b/c",
        "b/c/a",
        "b/c/a/module.car",
        "index"
    ]);
}
