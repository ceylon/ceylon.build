import ceylon.language.meta.declaration { FunctionDeclaration }

"The annotation for [[goal]]"
shared final annotation class GoalAnnotation(name, internal, dependencies)
        satisfies OptionalAnnotation<GoalAnnotation, FunctionDeclaration> {
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    shared String name;
    
    "If `true`, goal will be an internal goal which means
     it will only be accessible as a dependency but
     not directly from command line."
    shared Boolean internal;
    
    "Dependencies to other goals."
    shared [String*] dependencies;
    
    string => name;
}

"Annotation to mark a function as a goal
 and to specify its properties"
shared annotation GoalAnnotation goal(
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    String name = "",
    
    "If `true`, goal will be an internal goal which means
     it will only be accessible as a dependency but
     not directly from command line."
    Boolean internal = false,
    
    "Dependencies to other goals."
    [String*] dependencies = [])
        => GoalAnnotation(name, internal, dependencies);
