
"A [[GoalException]] is an exception that can be thrown by a goal
 but unlike for other exceptions, no stacktrace will be printed on
 error output stream for this one.
 
 Instead, the message will be written on the error output stream."
shared class GoalException(
        "Exception message"
        String message
    ) extends Exception(message) {}
    