"""a `Task` represents a `Goal` action.
   
   It takes in input a `Context` giving access to:
   - arguments passed to that task's goal
   - a `Writer` allowing the task to write output messages.
   
   It returns an `Outcome` object.
   In case the task execution is successful, task should return a `Success` object.
   Otherwise, it should return a `Failure` object."""
see(`function done`, `function failed`)
shared alias Task => Outcome(Context);
