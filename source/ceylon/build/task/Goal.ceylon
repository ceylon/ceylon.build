"""A `Goal` represents an action that can be launched by `ceylon.build.engine`
   
   A `Goal` has:
    - a `name` which must be unique inside a build configuration.
      `name` will be used from command line to ask for the `Goal` execution.
    - a `task` which represent the task to execute for that `Goal`.
      In case the task execution is successful, `task` method should return `true`, `false` otherwise.
    - a `dependencies` list that lists goals / goals groups that must be executed before this goal."""
shared class Goal(name, task, dependencies = []) satisfies Named {
    
    """Goal's name.
       
       This will be used from command line to identify the goal.
       This means that name must be unique inside a build configuration.
       
       In addition, name should match following regular expression `"[a-z][a-zA-Z0-9-.]*"`"""
    shared actual String name;
    
    "Task to execute"
    shared Task task;
    
    "List of dependencies that must be executed before this goal"
    shared {<Goal|GoalGroup>*} dependencies;
    
    string => name;
}
