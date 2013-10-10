"""A `GoalGroup` represents an action that can be launched by `ceylon.build.engine`
   
   A `GoalGroup` has:
   - a `name` which must be unique inside a build configuration.
   `name` will be used from command line to ask for the `GoalGroup` execution.
   - a `goals` list which represents the list of `Goal` and `GoalGroup` to execute.
   They will be executed in specified order unless dependencies are not satisfied
   in which case, goal execution list will be re-ordered to satisfy dependency graph."""
shared class GoalGroup(name, goals) satisfies Named {
    
    """GoalGroup's name
       
       This will be used from command line to identify the goal and so same rules that for `Goal.name`
       should be applied.
       
       This means that name must be unique inside a build configuration.
       
       In addition, name should match following regular expression `"[a-z][a-zA-Z0-9-]*"`"""
    shared actual String name;
    
    "Goals and or goals groups list to run.
     
     When a GoalGroup needs to be executed, its goals will be executed in the order defined in its `goals`
     attribute unless dependencies are not satisfied in which case, the goal execution list will be re-ordered
     to satisfy dependency graph."
    shared {<Goal|GoalGroup>+} goals;
    
    string => "``name``:``goals``";
}
