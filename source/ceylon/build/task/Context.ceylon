"""Represents the current context of a `Goal` execution.
   It contains arguments passed to the current `Goal` and also a `Writer` for output reporting."""
shared final class Context(arguments, writer) {
    
    "arguments for the current `Goal`"
    shared {String*} arguments;
    
    "The output writer"
    shared Writer writer;
}
