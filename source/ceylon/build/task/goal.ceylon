import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}

"The annotation for [[goal]]"
shared final annotation class GoalAnnotation(name)
        satisfies OptionalAnnotation<GoalAnnotation, FunctionOrValueDeclaration> {
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    shared String name;
    
    string => name;
}

"Annotation to mark a function as a goal
 and to specify its name"
shared annotation GoalAnnotation goal(
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    String name = "")
        => GoalAnnotation(name);
