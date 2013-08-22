"Abstraction of standard output and error output streams"
shared interface Writer {
    "Write a message on information output stream"
    shared formal void info(String message);
    
    "Write a message on error output stream"
    shared formal void error(String message);
    
    "Write an exception on error output stream"
    shared default void exception(Exception exception) => error(exception.message);
}

"Standard (console) implementation of `Writer`.
 
 Outputs are standard output for `info(String)` and
 standard error output for `error(String)` and `exception(Exception)`"
object consoleWriter satisfies Writer {
    
    "Write a message to standard output"
    shared actual void info(String message) {
        print(message);
    }
    
    "Write a message to standard error output"
    shared actual void error(String message) {
        process.writeErrorLine(message);
    }
    
    "Write an exception detailled message to standard error output"
    shared actual void exception(Exception exception) {
        exception.printStackTrace();
    }
}