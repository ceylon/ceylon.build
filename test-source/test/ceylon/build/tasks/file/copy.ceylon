import ceylon.file { File, Directory, Nil, Path, Visitor }
import ceylon.build.tasks.file { copyFiles, extensions, FileFilter }
import ceylon.collection { LinkedList }

void shouldCopyFileToFile() {
    Path output = initializeTestDirectory("shouldCopyFileToFile");
    value source = dataPath("simple-file/file");
    value destination = output.childPath("simple-file");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    copyFiles(source, destination);
    "Destination file should exist"
    assert(destination.resource is File);
}

void shouldCopyFileToDirectory() {
    Path output = initializeTestDirectory("shouldCopyFileToDirectory");
    value source = dataPath("simple-file/file");
    value destinationDirectory = output.childPath("directory");
    createDirectoryFromPath(destinationDirectory);
    value destinationFile = destinationDirectory.childPath("file");
    "Destination file shouldn't exist"
    assert(destinationFile.resource is Nil);
    copyFiles(source, destinationDirectory);
    "Destination file should exist"
    assert(destinationFile.resource is File);
}

void shouldCopyFileToFileInNonExistingDirectory() {
    Path output = initializeTestDirectory("shouldCopyFileToFileInNonExistingDirectory");
    value source = dataPath("simple-file/file");
    value destination = output.childPath("non-existing-directory/simple-file");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    copyFiles(source, destination);
    "Destination file should exist"
    assert(destination.resource is File);
}

void shouldCopyDirectoryToDirectory() {
    Path output = initializeTestDirectory("shouldCopyDirectoryToDirectory");
    value source = dataPath("simple-directory");
    value destination = output.childPath("simple-directory");
    createDirectoryFromPath(destination);
    copyFiles(source, destination);
    value destinationResource = destination.resource;
    "Destination file should exist"
    assert(is Directory destinationResource);
    value children = { for (resource in destinationResource.children()) shortname(resource.path) }.sequence;
    "Destination directory should file-a and file-b"
    assert(children == ["file-a", "file-b"]);
}

void shouldCopyDirectoryToNonExistingDirectory() {
    Path output = initializeTestDirectory("shouldCopyDirectoryToNonExistingDirectory");
    value source = dataPath("simple-directory");
    value destination = output.childPath("simple-directory");
    "Destination file shouldn't exist yet"
    assert(destination.resource is Nil);
    copyFiles(source, destination);
    value destinationResource = destination.resource;
    "Destination file should exist"
    assert(is Directory destinationResource);
    value children = { for (resource in destinationResource.children()) shortname(resource.path) }.sequence;
    "Destination directory should file-a and file-b"
    assert(children == ["file-a", "file-b"]);
}

void shouldCopyTree() {
    Path output = initializeTestDirectory("shouldCopyTree");
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
    "Destination directory should contain copied files and directories"
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
