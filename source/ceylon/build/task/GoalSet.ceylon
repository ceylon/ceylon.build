"Returns a function that will prefix the Goal name using the given `prefix`"
shared String(String) prefix(String prefix) => (String name) => prefix + name;

"Returns a function that will suffix the Goal name using the given `suffix`"
shared String(String) suffix(String suffix) => (String name) => name + suffix;

"Returns a function that will not change the Goal name"
shared String(String) keepCurrentName() => (String name) => name;

"""A `GoalSet` represents a set of goals that can be imported together"""
shared class GoalSet(goals) {
    
    "List of goals and groups to import"
    shared {<Goal|GoalGroup>+} goals;
    
    string => "GoalSet``goals``";
}