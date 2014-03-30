import ceylon.language.meta.declaration { ValueDeclaration, FunctionOrValueDeclaration }

shared abstract class NoOp() of noop {}

shared object noop extends NoOp() {}

"The annotation for [[goal]]"
shared final annotation class GoalAnnotation(name)
        satisfies OptionalAnnotation<GoalAnnotation, FunctionOrValueDeclaration> {
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    shared String name;
    
    string => name;
}

"Annotation to mark a function as a goal
 and to specify its properties"
shared annotation GoalAnnotation goal(
    
    "Goal name. If no name is provided, annotated
     element's name will be used as name."
    String name = "")
        => GoalAnnotation(name);

shared final annotation class DependsOnAnnotation(dependencies)
        satisfies SequencedAnnotation<DependsOnAnnotation, FunctionOrValueDeclaration> {
    
    "Dependencies to other goals."
    shared FunctionOrValueDeclaration* dependencies;
}

shared annotation DependsOnAnnotation dependsOn(
    
    "Dependencies to other goals."
    FunctionOrValueDeclaration* dependencies)
        => DependsOnAnnotation(*dependencies);

shared final annotation class AttachToAnnotation(phase)
        satisfies SequencedAnnotation<AttachToAnnotation, FunctionOrValueDeclaration> {
    
    "Phase (Goal) to which this goal should be attached."
    shared FunctionOrValueDeclaration phase;
}

shared annotation AttachToAnnotation attachTo(
    
    "Phase (Goal) to which this goal should be attached."
    FunctionOrValueDeclaration phase)
        => AttachToAnnotation(phase);

"The annotation for [[include]]"
shared final annotation class IncludeAnnotation()
        satisfies OptionalAnnotation<IncludeAnnotation, ValueDeclaration> {
}

"Annotation to mark a function as an import of goals in returned object"
shared annotation IncludeAnnotation include() => IncludeAnnotation();
