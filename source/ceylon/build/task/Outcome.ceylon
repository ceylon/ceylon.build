"Represent the outcome of a task"
shared abstract class Outcome(message) of Success | Failure {
    
    "Message giving outcome details"
    shared String message;
}

"Represents a failed outcome"
shared class Failure(String message, exception) extends Outcome(message) {
    
    "Exception (if any) that caused the failure"
    shared Exception? exception;
}

"Returns a failure `Outcome`"
shared Failure failed(
    "Message describing the failure"
    String message = "",
    "Exception (if any) that caused the failure"
    Exception? exception = null) => Failure(message, exception);

"Represents a successful outcome"
shared class Success(String message) extends Outcome(message) {}

"Returns a success `Outcome`"
shared Success done(
    "Message reporting the success"
    String message = "") => Success(message);
