import ceylon.build.task { Writer }

"Standard (console) implementation of `Writer`.
 
 Outputs are standard output for `info(String)` and
 standard error output for `error(String)` and `exception(Exception)`"
shared object consoleWriter satisfies Writer {
    
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