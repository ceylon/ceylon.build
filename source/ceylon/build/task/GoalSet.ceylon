"Returns a function that will prefix the Goal name using the given `prefix`"
shared String(String) prefix(String prefix) => (String name) => prefix + name;

"Returns a function that will suffix the Goal name using the given `suffix`"
shared String(String) suffix(String suffix) => (String name) => name + suffix;

"Returns a function that will not change the Goal name"
shared String(String) keepCurrentName() => (String name) => name;

"""A `GoalSet` represents a set of goals that can be imported together
   
   A `GoalSet` has:
   - a `rename` function which will be applied to each of the embed goals.
   - a `Goal` and  `GoalGroup` iterable holding goals and groups to import in the current build configuration"""
shared class GoalSet(goals, rename = keepCurrentName()) {
    
    "Rename function to apply to each of the embed goals.
     That rename function must produce valid goal names according to `Goal.name` documentation."
    shared String(String) rename;
    
    "List of goals and groups to import"
    shared {<Goal|GoalGroup>+} goals;
    
    string => "GoalSet`` [ for (goal in goals) rename(goal.name) ]``";
}