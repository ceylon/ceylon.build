import ceylon.file { Path, File, Directory, Visitor }
import ceylon.build.task { TaskDefinition, Context }

"""Returns a `TaskDefinition` to delete files and directories inside `path` (`path` included)
   
   All files in `path` matching `filter` will be deleted.
   
   If some files in a directory don't match `filter`, those files won't be deleted.
   As a consequence, parent directory will not be deleted too"""
shared TaskDefinition delete(
        "Path to recursively delete"
        Path path,
        "Delete `FileFilter` has to return `true` to delete files, `false` to keep them"
        FileFilter filter = allFiles
        ) {
    return function(Context context) {
        context.writer.info("deleting ``path``");
        deletePath(path, filter);
        return true;
    };
}

"""Delete files and directories inside `path` (`path` included)
   
   All files in `path` matching `filter` will be deleted.
   
   If some files in a directory don't match `filter`, those files won't be deleted.
   As a consequence, parent directory will not be deleted too"""
shared void deletePath(
        "Path to recursively delete"
        Path path,
        "Delete `FileFilter` has to return `true` to delete files, `false` to keep them"
        FileFilter filter = allFiles
        ) {
    path.visit(DeleteVisitor(path, filter));
}

class DeleteVisitor(
        "Path to delete recursively"
        Path path,
        "Delete `FileFilter` has to return `true` to delete files, `false` to keep them"
        FileFilter filter
        ) extends Visitor() {
    
    shared actual void afterDirectory(Directory directory) {
        if (directory.children("*").empty) {
            directory.delete();
        }
    }
    
    shared actual void file(File file) {
        if (filter(file)) {
            file.delete();
        }
    }
}
