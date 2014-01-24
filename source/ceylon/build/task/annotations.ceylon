import ceylon.language.meta.declaration { ValueDeclaration, FunctionDeclaration }

shared void noop() {}

"The annotation for [[goal]]"
shared final annotation class GoalAnnotation(name
//, dependencies
) satisfies OptionalAnnotation<GoalAnnotation, FunctionDeclaration> {
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    shared String name;
    
    //"Dependencies to other goals."
    //shared [FunctionDeclaration*] dependencies;
    
    string => name;
}

"Annotation to mark a function as a goal
 and to specify its properties"
shared annotation GoalAnnotation goal(
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    String name = "",
    
    "Dependencies to other goals."
    [FunctionDeclaration*] dependencies = [])
        => GoalAnnotation(name);


"The annotation for [[include]]"
shared final annotation class IncludeAnnotation()
        satisfies OptionalAnnotation<IncludeAnnotation, ValueDeclaration> {
}

"Annotation to mark a function as an import of goals in returned object"
shared annotation IncludeAnnotation include() => IncludeAnnotation();
