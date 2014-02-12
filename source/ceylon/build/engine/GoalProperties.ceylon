
shared final class GoalProperties(internal, task, dependencies) {
    
    "If `true`, goal will be an internal goal which means
     it will only be accessible as a dependency but
     not directly from command line."
    shared Boolean internal;
    
    "Tasks to be run"
    shared Anything()? task;
    
    "Dependencies to other goals."
    shared [String*] dependencies;
    
    string => "[internal:``internal``, dependencies: ``dependencies``]";
}
