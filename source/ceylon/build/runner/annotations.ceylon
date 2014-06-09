import ceylon.build.engine {
    GoalDefinitionsBuilder,
    Goal
}
import ceylon.build.task {
    AttachToAnnotation
}
import ceylon.collection {
    HashMap,
    ArrayList
}
import ceylon.language.meta.declaration {
    Module,
    FunctionOrValueDeclaration
}

GoalDefinitionsBuilder|[InvalidGoalDeclaration+] readAnnotations(Module mod) {
    value invalidDeclarations = ArrayList<InvalidGoalDeclaration>();
    value goals = GoalDefinitionsBuilder();
    value declarations = findDeclarations(mod);
    value phases = phasesDependencies([ for (declaration -> instance in declarations) declaration ]);
    for (declaration -> instance in declarations) {
        value goal = goalDefinition(declaration, phases, instance != toplevel then instance else null);
        switch (goal)
        case (is Goal) {
            goals.add(goal);
        } case (is InvalidGoalDeclaration) {
            invalidDeclarations.add(goal);
        }
    }
    if (nonempty seq = invalidDeclarations.sequence()) {
        return seq;
    }
    return goals;
}

object toplevel {}

[<FunctionOrValueDeclaration->Object>*] findDeclarations(Module mod) {
    value topLevelGoalDeclarations = { for (declaration in findTopLevelAnnotatedGoals(mod)) declaration -> toplevel };
    value annotatedIncludes = findAnnotatedIncludes(mod);
    value declarationsFromIncludes = goalDeclarationsFromIncludes(annotatedIncludes);
    return concatenate(topLevelGoalDeclarations, declarationsFromIncludes);
}

shared Map<FunctionOrValueDeclaration, [FunctionOrValueDeclaration*]> phasesDependencies(
    {FunctionOrValueDeclaration*} declarations
) {
    value phases = HashMap<FunctionOrValueDeclaration, ArrayList<FunctionOrValueDeclaration>>();
    for (declaration in declarations) {
        for (annotation in declaration.annotations<AttachToAnnotation>()) {
            ArrayList<FunctionOrValueDeclaration> list;
            if (exists listFromMap = phases.get(annotation.phase)) {
                list = listFromMap;
            } else {
                list = ArrayList<FunctionOrValueDeclaration>();
                phases.put(annotation.phase, list);
            }
            list.add(declaration);
        }
    }
    return phases.mapItems(
        (FunctionOrValueDeclaration key, ArrayList<FunctionOrValueDeclaration> item) => item.sequence());
}
