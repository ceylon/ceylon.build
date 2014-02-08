"Represents the outcome of a task"
shared abstract class Outcome() of ok | Failure {}

"Represents a successful outcome."
shared object ok extends Outcome() {}

"Represents a failed outcome"
shared class Failure(exception) extends Outcome() {
    
    "Exception (if any) that caused the failure"
    shared Exception exception;
 }

