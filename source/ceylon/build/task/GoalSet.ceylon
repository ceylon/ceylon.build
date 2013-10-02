"Returns a function that will prefix the Goal name using the given `prefix`"
shared String(String) prefix(String prefix) => (String name) => prefix + name;

"Returns a function that will not change the Goal name"
shared String(String) keepCurrentName() => (String name) => name;

"Set of goals that can be imported and renamed together"
shared class GoalSet(goals, rename = keepCurrentName()) {
    
    "List of goals to import"
    shared String(String) rename;
    
    "Rename function to apply to each goal"
    shared {Goal+} goals;
    
    string => "GoalSet`` [ for (goal in goals) rename(goal.name) ]``";
}