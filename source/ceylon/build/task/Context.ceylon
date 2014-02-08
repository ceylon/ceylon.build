"""Represents the current context of a `Goal` execution.
   It contains arguments passed to the current `Goal` and also a `Writer` for output reporting."""
shared final class Context(arguments, writer) {
    
    "arguments for the current `Goal`"
    shared [String*] arguments;
    
    "The output writer"
    shared Writer writer;
}

shared Context context {
    if (exists ctx = _context) {
        return ctx;
    }
    throw Exception("Context accessed from outside a task");
}

variable Context? _context = null;

shared void setContextForTask([String*] arguments, Writer writer) {
    _context = Context(arguments, writer);
}
shared void clearTaskContext() {
    _context = null;
}
