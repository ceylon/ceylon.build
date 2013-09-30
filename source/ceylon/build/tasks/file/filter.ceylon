import ceylon.file { File }

"A `FileFilter` is a function that returns `true` when the file given in input match the filter"
see(`function extensions`)
shared alias FileFilter => Boolean(File);

"Returns a `FileFilter` that will match all files"
shared FileFilter allFiles = (File file) => true;

"Returns a FileFilter that will return `true` when given file extension is in `extensions`"
shared FileFilter extensions(String* extensions) {
    return function(File file) {
        for (extension in extensions) {
            if (file.name.endsWith(".``extension``")) {
                return true;
            }
        }
        return false;
    };
}
