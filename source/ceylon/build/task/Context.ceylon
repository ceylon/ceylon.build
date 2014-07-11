
"""Represents the current context of a `Goal` execution.
   It contains arguments passed to the current `Goal` and also a `Writer` for output reporting."""
shared final class Context(arguments, writer) {
    
    "arguments for the current `Goal`"
    shared [String*] arguments;
    
    "The output writer"
    shared Writer writer;
}

"Returns context for `Goal` currently being executed."
throws(`class Exception`, "when context is accessed from outside a [[goal]]")
shared Context context {
    if (exists ctx = _context) {
        return ctx;
    }
    throw Exception("Context accessed from outside a goal");
}

variable Context? _context = null;

"_This should not be used, only `ceylon.build.engine` should._
 
 replace current [[context]] by a new one based on `arguments` and `writer`"
shared void setContextForTask([String*] arguments, Writer writer) {
    _context = Context(arguments, writer);
}

"_This should not be used, only `ceylon.build.engine` should_.
 
 replace previous [[context]] by setting it to `null`"
shared void clearTaskContext() {
    _context = null;
}
