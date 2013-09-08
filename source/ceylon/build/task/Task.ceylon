"""A `Goal` represent an action that can be launched by `ceylon.build.engine`
   
   A `Goal` has:
    - a `name` which must be unique inside a build configuration.
      `name` will be used from command line to ask for the `Goal` execution.
    - a `task` of type `Task` which represent the task to execute for that `Goal`.
      In case the task execution is successful, `task` method should return `true`, `false` otherwise.
    - a `dependencies` list that lists goals that must be executed before this one.
  """
shared class Goal(name, task, dependencies = []) satisfies Identifiable {
    
    shared String name;
    
    shared Task task;
    
    shared {Goal*} dependencies;
    
    string => name;
    
    hash => name.hash;
    
    shared actual Boolean equals(Object that) {
        if (is Goal that) {
            return that.name == name;
        }
        return false;
    }
}

"""Represents a `Goal` action.
   In case the task execution is successful, should return `true`, `false` otherwise."""
shared alias Task => Boolean(Context);

"""Represents the current context of a `Goal` execution.
   It contains arguments passed to the current `Goal` and also a `Writer` for output reporting."""
shared class Context(arguments, writer) {
    
    "arguments for the current `Goal`"
    shared {String*} arguments;
    
    "The output writer"
    shared Writer writer;
}
