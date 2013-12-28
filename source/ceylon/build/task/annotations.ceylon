import ceylon.language.meta.declaration { FunctionDeclaration }

shared final annotation class GoalAnnotation(name)
        satisfies OptionalAnnotation<GoalAnnotation, FunctionDeclaration> {
    shared String name;
    
    string => name;
}

shared annotation GoalAnnotation goal(String name = "", [FunctionDeclaration*] dependencies = [])
        => GoalAnnotation(name);
