"Abstraction of standard output and error output streams"
shared interface Writer {
    "Write a message on information output stream"
    shared formal void info(String message);
    
    "Write a message on error output stream"
    shared formal void error(String message);
    
    "Write an exception on error output stream"
    shared default void exception(Exception exception) => error(exception.message);
}