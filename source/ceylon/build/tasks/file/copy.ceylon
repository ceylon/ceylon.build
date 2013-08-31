import ceylon.build.task { TaskDefinition, Context }
import ceylon.file { Path, Resource, Nil, File, Directory, Visitor }

shared class IOException(String message) extends Exception(message) {}
shared class CreateDirectoryException(String message) extends IOException(message) {}
shared class FileCopyException(String message) extends IOException(message) {}

"""Returns a `TaskDefinition` to copy files and directories from `source` to `destination`
   
   All files in `source` matching `filter` will be copied to same relative path from `source` into `destination`.
   
   If `destination` doesn't exist and `source` is a `Directory`, it will attempt to create missing directories.
   For example, if `destination` is set to `"foo/bar/baz"` but only `"foo"` exists, directories `"foo/bar"` and
   `"foo/bar/baz"` will be created (except if `"foo"` is a `File` in which case `CreateDirectoryException` will
   be thrown)."""
throws(
    `FileCopyException`,
    "When files with same names already exists in destination and `overwrite` is set to `false`")
throws(
    `CreateDirectoryException`,
    "If destination doesn't exist and can't be created because parent element in path is not a `Directory`")
shared TaskDefinition copy(
        "Source path from where files will be taken"
        Path source,
        "Destination path where files will be copied"
        Path destination,
        """If `true`, will overwrite already existing files.
           If `false` and a file with a same name already exist in `destination`, `FileCopyException` will be raised"""
        Boolean overwrite = false,
        "Copy `FileFilter` has to return `true` to copy files, `false` to copy them"
        FileFilter filter = allFiles
        ) {
    return function(Context context) {
        context.writer.info("copying ``source`` to ``destination``");
        try {
            copyFiles(source, destination, overwrite, filter);
            return true;
        } catch (IOException exception) {
            context.writer.error("error during copy");
            context.writer.error(exception.message);
            return false;
        }
    };
}

"""Copies files and directories from `source` to `destination`
   
   All files in `source` matching `filter` will be copied to same relative path from `source` into `destination`.
   
   If `destination` doesn't exist and `source` is a `Directory`, it will attempt to create missing directories.
   For example, if `destination` is set to `"foo/bar/baz"` but only `"foo"` exists, directories `"foo/bar"` and
   `"foo/bar/baz"` will be created (except if `"foo"` is a `File` in which case `CreateDirectoryException` will
   be thrown)."""
throws(
    `FileCopyException`,
    "When files with same names already exists in destination and `overwrite` is set to `false`")
throws(
    `CreateDirectoryException`,
    "If destination doesn't exist and can't be created because parent element in path is not a `Directory`")
shared void copyFiles(
        "Source path from where files will be taken"
        Path source,
        "Destination path where files will be copied"
        Path destination,
        """If `true`, will overwrite already existing files.
           If `false` and a file with a same name already exist in `destination`, `FileCopyException` will be raised"""
        Boolean overwrite = false,
        "Copy `FileFilter` has to return `true` to copy files, `false` to copy them"
        FileFilter filter = allFiles
        ) {
    value destinationResource = destination.resource;
    value sourceResource = source.resource;
    if (is Directory sourceResource, is Nil destinationResource) {
        createDirectory(destinationResource);
    }
    source.visit(CopyVisitor(source, destination, overwrite, filter));
}

void createDirectory(Resource directory) {
    if (is Nil directory) {
        createDirectory(directory.path.parent.resource);
        directory.createDirectory();
    } else if (is File directory) {
        throw CreateDirectoryException("cannot create sub-directory of a file: ``directory.path``");
    }
}

class CopyVisitor(
        Path source,
        Path destination,
        Boolean overwrite,
        FileFilter filter
        ) extends Visitor() {
    
    shared actual Boolean beforeDirectory(Directory directory) {
        value target = targetPath(directory.path).resource;
        if (is Nil target) {
            target.createDirectory();
        }
        return true;
    }
    
    shared actual void file(File file) {
        if (filter(file)) {
            value target = targetPath(file.path).resource;
            if (is Nil target) {
                file.copy(target);
            } else if (is File target) {
                if (overwrite) {
                    file.copyOverwriting(target);
                } else {
                    throw FileCopyException("destination file ``target.path`` already exists");
                }
            } else {
                throw FileCopyException("destination file ``target.path`` already exists and is a directory");
            }
        }
    }
    
    Path targetPath(Path path) {
        value pathFromRootSource = path.relativePath(source);
        return destination.childPath(pathFromRootSource.string);
    }
}
