"""A `Goal` represent an action that can be launched by `ceylon.build.engine`
   
   A `Goal` has:
    - a `name` which must be unique inside a build configuration.
      `name` will be used from command line to ask for the `Goal` execution.
    - a `task` of type `Task` which represent the task to execute for that `Goal`.
      In case the task execution is successful, `task` method should return `true`, `false` otherwise.
    - a `dependencies` list that lists goals that must be executed before this one.
  """
shared class Goal(name, task, dependencies = []) satisfies Named & Identifiable {
    
    shared actual String name;
    
    shared Task task;
    
    shared {<Goal|GoalGroup>*} dependencies;
    
    string => name;
    
    hash => name.hash;
    
    shared actual Boolean equals(Object that) {
        if (is Goal that) {
            return that.name == name;
        }
        return false;
    }
}
