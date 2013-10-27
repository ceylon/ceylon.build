"Represents the outcome of a task"
shared abstract class Outcome(message) of Success | Failure {
    
    "Message giving outcome details"
    shared String message;
}

"Represents a failed outcome"
shared class Failure(
    "Message describing the failure"
    String message = "",
    "Exception (if any) that caused the failure"
    shared Exception? exception = null) extends Outcome(message) { }

"Represents a successful outcome with a message giving details about the outcome.
  
 [[done]] attribute represents a success without any outcome details."
see(`value done`)
shared class Success(
    "Message reporting the success"
    String message) extends Outcome(message) {}

"Returns a success `Outcome`"
shared Success done = Success("");
