import ceylon.language.meta { type }
import ceylon.language.meta.declaration { Module, FunctionDeclaration, ValueDeclaration, FunctionOrValueDeclaration, ClassDeclaration }
import ceylon.language.meta.model { Value, Function }
import ceylon.build.engine { GoalProperties, GoalDefinitionsBuilder, Goal }
import ceylon.build.task { GoalAnnotation, IncludeAnnotation }

GoalDefinitionsBuilder|[InvalidGoalDeclaration+] readAnnotations(Module mod) {
    value invalidDeclarations = SequenceBuilder<InvalidGoalDeclaration>();
    value goals = GoalDefinitionsBuilder();
    for (declaration in findPackageMembersAnnotatedWithGoals(mod)) {
        value goal = goalDefinition(declaration);
        fillGoalsAndInvalidDeclarations(goal, goals, invalidDeclarations);
    }
    for (declaration in findAnnotatedIncludes(mod)) {
        for (goal in goalsDefinition(declaration)) {
            fillGoalsAndInvalidDeclarations(goal, goals, invalidDeclarations);
        }
    }
    if (nonempty seq = invalidDeclarations.sequence) {
        return seq;
    }
    return goals;
}

void fillGoalsAndInvalidDeclarations(
        Goal|InvalidGoalDeclaration goal,
        GoalDefinitionsBuilder goals,
        SequenceBuilder<InvalidGoalDeclaration> invalidDeclarations) {
    switch (goal)
    case (is Goal) {
        goals.add(goal);
    } case (is InvalidGoalDeclaration) {
        invalidDeclarations.append(goal);
    }
}

shared [FunctionDeclaration*] findPackageMembersAnnotatedWithGoals(Module mod) {
    value annotatedGoals = SequenceBuilder<FunctionDeclaration>();
    for (pkg in mod.members) {
        annotatedGoals.appendAll(pkg.annotatedMembers<FunctionDeclaration, GoalAnnotation>());
    }
    return annotatedGoals.sequence;
}

Goal|InvalidGoalDeclaration goalDefinition(FunctionDeclaration declaration, Object? container = null) {
    value annotation = goalAnnotation(declaration);
    value name = goalName(annotation, declaration);
    value task = extractTasks(declaration, container);
    if (isFunctionWithoutParameters(declaration)) {
        value internal = declaration.annotations<SharedAnnotation>().size == 0;
        value dependencies = [ ];//for (dependency in annotation.dependencies) goalName(goalAnnotation(declaration), dependency) ];
        return Goal(name, GoalProperties(internal, task, dependencies));
    }
    return InvalidGoalDeclaration(declaration);
}

"Returns `GoalAnnotation` associated to this declaration"
throws(`class AssertionException`, "When no `GoalAnnotation` is found on this declaration")
shared GoalAnnotation goalAnnotation(FunctionOrValueDeclaration declaration) {
    value annotations = declaration.annotations<GoalAnnotation>();
    assert (nonempty annotations, annotations.size == 1);
    return annotations.first;
}

shared String goalName(GoalAnnotation annotation, FunctionOrValueDeclaration declaration) {
    return annotation.name.empty then declaration.name else annotation.name;
}

Anything() extractTasks(FunctionDeclaration declaration, Object? container = null) {
    value func = functionFromDeclaration(declaration, container);
    return tasksFromFunction(func);
}

Value valueFromDeclaration(ValueDeclaration valueDeclaration, Anything containerInstance) {
    if (exists containerInstance) {
        value containerType = type(containerInstance);
        assert(exists attribute = containerType.getAttribute<Nothing, Anything>(valueDeclaration.name));
        return attribute.bind(containerInstance);
    }
    return valueDeclaration.apply<Anything>();
}

Function<Anything, []> functionFromDeclaration(
    FunctionDeclaration declaration, Object? containerInstance) {
    if (exists containerInstance) {
        value containerType = type(containerInstance);
        assert(exists method = containerType.getMethod<Nothing, Anything, []>(declaration.name));
        return method.bind(containerInstance);
    }
    return declaration.apply<Anything, []>();
}

shared Boolean isFunctionWithoutParameters(FunctionDeclaration declaration) {
    return declaration.parameterDeclarations.empty && declaration.typeParameterDeclarations.empty;
}

shared Anything() tasksFromFunction(Function<Anything,[]> func) => () => func.apply();

shared [ValueDeclaration*] findAnnotatedIncludes(Module mod) {
    value annotatedIncludes = SequenceBuilder<ValueDeclaration>();
    for (pkg in mod.members) {
        value includesFromPackage = pkg.annotatedMembers<ValueDeclaration, IncludeAnnotation>();
        annotatedIncludes.appendAll(includesFromPackage);
    }
    return annotatedIncludes.sequence;
}

{<Goal|InvalidGoalDeclaration>*} goalsDefinition(ValueDeclaration declaration) {
    value instance = declaration.apply<Object>().get();
    value instanceTypeDeclaration = type(instance).declaration;
    value goals = SequenceBuilder<Goal|InvalidGoalDeclaration>();
    value declarations = findClassMembersAnnotatedWithGoal(instanceTypeDeclaration);
    for (goalDeclaration in declarations) {
        goals.append(goalDefinition(goalDeclaration, instance));
    }
    return goals.sequence;
}

FunctionDeclaration[] findClassMembersAnnotatedWithGoal(
        ClassDeclaration instanceTypeDeclaration) {
    return instanceTypeDeclaration.
            annotatedDeclaredMemberDeclarations<FunctionDeclaration, GoalAnnotation>();
}

class InvalidGoalDeclaration(declaration) {
    shared FunctionOrValueDeclaration declaration;
}
