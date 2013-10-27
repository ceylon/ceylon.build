import ceylon.build.task { Task, Context, done, failed }
import ceylon.file { Path, Resource, Nil, File, Directory, Visitor }

shared class IOException(String message) extends Exception(message) {}
shared class CreateDirectoryException(String message) extends IOException(message) {}
shared class FileCopyException(String message) extends IOException(message) {}

"""Returns a `Task` to copy files and directories from `source` to `destination` using [[copyFiles]]"""
see(`function copyFiles`)
shared Task copy(
        "Source path from where files will be taken"
        Path source,
        "Destination path where files will be copied"
        Path destination,
        """If `true`, will overwrite already existing files.
           If `false` and a file with a same name already exist in `destination`, `FileCopyException` will be raised"""
        Boolean overwrite = false,
        "Copy `FileFilter` has to return `true` to copy files, `false` not to copy them"
        FileFilter filter = allFiles
        ) {
    return function(Context context) {
        context.writer.info("copying ``source`` to ``destination``");
        try {
            copyFiles(source, destination, overwrite, filter);
            return done();
        } catch (IOException exception) {
            return failed("error during copy from ``source`` to ``destination``", exception);
        }
    };
}

"""Copies files and directories from `source` to `destination`
   
   All files in `source` matching `filter` will be copied to same relative path from `source` into `destination`.
   
   If `destination` doesn't exist, it will attempt to create missing directories.
   
   This function acts the same way as the `cp` Unix command does when a single file is given in input.
   This means that if `destination` exists and is a directory, source file will be copied under that directory.
   Otherwise, it will be copied directly to `destination` path.
   
   This has implications on missing directories creation process:
   - In case `source` is a `Directory`: will create `destination` directory.
   
   For example, if `destination` is set to `"foo/bar/baz"` but only `"foo"` exists, directories `"foo/bar"` and
   `"foo/bar/baz"` will be created.
   - In case `source` is a `File`: will create missing directories until `destination`'s parent directory included.
   
   For example, if `destination` is set to `"foo/bar/baz"` but only `"foo"` exists, directory `"foo/bar"`
   will be created."""
throws(
    `class FileCopyException`,
    "When files with same names already exists in destination and `overwrite` is set to `false`")
throws(
    `class CreateDirectoryException`,
    "If destination doesn't exist and can't be created because parent element in path is not a `Directory`")
shared void copyFiles(
        "Source path from where files will be taken"
        Path source,
        "Destination path where files will be copied"
        Path destination,
        """If `true`, will overwrite already existing files.
           If `false` and a file with a same name already exist in `destination`, `FileCopyException` will be raised"""
        Boolean overwrite = false,
        "Copy `FileFilter` has to return `true` to copy files, `false` not to copy them"
        FileFilter filter = allFiles
        ) {
    createDestinationDirectory(source, destination);
    Path targettedDestination = getRealDestinationPath(source, destination);
    source.visit(CopyVisitor(source, targettedDestination, overwrite, filter));
}

void createDestinationDirectory(Path source, Path destination) {
    value sourceResource = source.resource;
    value destinationResource = destination.resource;
    if (destinationResource is Nil) {
        if (is Directory sourceResource) {
            createDirectory(destination.resource);
        } else if (is File sourceResource) {
            value parent = destination.absolutePath.parent.resource;
            if (parent is Nil) {
                createDirectory(parent);
            }
        }
    }
}

Path getRealDestinationPath(Path source, Path originalDestination) {
    Path targettedDestination;
    if (source.resource is File, originalDestination.resource is Directory) {
        [String*] elements = source.elements;
        assert(nonempty elements);
        value name = elements.last;
        targettedDestination = originalDestination.childPath(name);
    } else {
        targettedDestination = originalDestination;
    }
    return targettedDestination;
}

"Recursivley create directory"
throws(`class CreateDirectoryException`, "when last parent in hierachy is a file")
shared void createDirectory(Resource directory) {
    if (is Nil directory) {
        createDirectory(directory.path.absolutePath.parent.resource);
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
