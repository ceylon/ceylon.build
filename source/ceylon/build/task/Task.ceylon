"""a `Task` represents a `Goal` action.
   
   It takes in input a `Context` giving access to:
   - arguments passed to that task's goal
   - a `Writer` allowing the task to write output messages.
   
   In case the task execution is successful, task should return `true`, `false` otherwise."""
shared alias Task => Boolean(Context);
