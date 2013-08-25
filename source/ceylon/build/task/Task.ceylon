"""A `Task` represent an action that can be launched by `ceylon.build.engine`
   A `Task` has:
    - a `name` which must be unique inside a build configuration.
      `name` will be used from command line to ask for the `Task` execution.
    - a `process` which represent the action to execute for that `Task`.
      In case the action execution is successful, `process` method should return `true`, `false` otherwise.
    - a `dependencies` list that list tasks that must be executed before this one.
  """
shared class Task(name, process, dependencies = []) satisfies Identifiable {
    
    shared String name;
    
    shared TaskDefinition process;
    
    shared {Task*} dependencies;
    
    string => name;
    
    hash => name.hash;
    
    shared actual Boolean equals(Object that) {
        if (is Task that) {
            return that.name == name;
        }
        return false;
    }
}

"""Represents a `Task` action.
   In case the action execution is successful, `process` method should return `true`, `false` otherwise."""
shared alias TaskDefinition => Boolean(Context);

"""Represents the current context of a `Task` execution.
   It contains arguments passed to the current `Task` and also a `Writer` for output reporting."""
shared class Context(arguments, writer) {
    
    "arguments for the current `Task`"
    shared {String*} arguments;
    
    "The output writer"
    shared Writer writer;
}
