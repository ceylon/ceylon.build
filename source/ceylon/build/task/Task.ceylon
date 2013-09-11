"""Represents a `Goal` action.
   In case the task execution is successful, should return `true`, `false` otherwise."""
shared alias Task => Boolean(Context);

"""Represents the current context of a `Goal` execution.
   It contains arguments passed to the current `Goal` and also a `Writer` for output reporting."""
shared class Context(arguments, writer) {
    
    "arguments for the current `Goal`"
    shared {String*} arguments;
    
    "The output writer"
    shared Writer writer;
}
