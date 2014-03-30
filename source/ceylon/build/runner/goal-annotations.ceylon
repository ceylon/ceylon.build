import ceylon.language.meta { type }
import ceylon.language.meta.declaration { Module, FunctionDeclaration, ValueDeclaration, FunctionOrValueDeclaration }
import ceylon.language.meta.model { Value, Function }
import ceylon.build.engine { GoalProperties, Goal }
import ceylon.build.task { GoalAnnotation, NoOp, DependsOnAnnotation }

shared [FunctionOrValueDeclaration*] findTopLevelAnnotatedGoals(Module mod) {
    value annotatedGoals = SequenceBuilder<FunctionOrValueDeclaration>();
    for (pkg in mod.members) {
        annotatedGoals.appendAll(pkg.annotatedMembers<FunctionOrValueDeclaration, GoalAnnotation>());
    }
    return annotatedGoals.sequence;
}

shared Goal|InvalidGoalDeclaration goalDefinition(
    FunctionOrValueDeclaration declaration,
    Map<FunctionOrValueDeclaration, [FunctionOrValueDeclaration*]> phases,
    Object? container = null) {
    value annotation = goalAnnotation(declaration);
    value name = goalName(annotation, declaration);
    if (checkSignature(declaration, container)) {
        value callable = extractCallable(declaration, container);
        value internal = declaration.annotations<SharedAnnotation>().size == 0;
        value dependencies = buildDependencies(declaration, phases);
        return Goal(name, GoalProperties(internal, callable, dependencies));
    }
    return InvalidGoalDeclaration(declaration);
}

"Returns `GoalAnnotation` associated to this declaration"
throws(`class AssertionError`, "When no `GoalAnnotation` is found on this declaration")
GoalAnnotation goalAnnotation(FunctionOrValueDeclaration declaration) {
    value annotations = declaration.annotations<GoalAnnotation>();
    assert (nonempty annotations, annotations.size == 1);
    return annotations.first;
}

String goalName(GoalAnnotation annotation, FunctionOrValueDeclaration declaration) {
    return annotation.name.empty then declaration.name else annotation.name;
}

Anything()? extractCallable(FunctionOrValueDeclaration declaration, Object? container = null) {
    switch (declaration)
    case (is FunctionDeclaration) {
        value func = functionModelFromDeclaration(declaration, container);
        return functionModelToFunction(func);
    } case (is ValueDeclaration) {
        return null;
    }
}

Value valueModelFromDeclaration(ValueDeclaration valueDeclaration, Anything containerInstance) {
    if (exists containerInstance) {
        value containerType = type(containerInstance);
        assert(exists attribute = containerType.getAttribute<Nothing, Anything>(valueDeclaration.name));
        return attribute.bind(containerInstance);
    }
    return valueDeclaration.apply<Anything>();
}

Function<Anything, []> functionModelFromDeclaration(
    FunctionDeclaration declaration, Object? containerInstance) {
    if (exists containerInstance) {
        value containerType = type(containerInstance);
        assert(exists method = containerType.getMethod<Nothing, Anything, []>(declaration.name));
        return method.bind(containerInstance);
    }
    return declaration.apply<Anything, []>();
}

Boolean checkSignature(FunctionOrValueDeclaration declaration, Anything containerInstance) {
    switch (declaration)
    case (is FunctionDeclaration) {
        return isFunctionWithoutParameters(declaration);
    } case (is ValueDeclaration) {
        return isNoOp(declaration, containerInstance);
    }
}

Boolean isFunctionWithoutParameters(FunctionDeclaration declaration)
    => declaration.parameterDeclarations.empty && declaration.typeParameterDeclarations.empty;

Boolean isNoOp(ValueDeclaration declaration, Anything containerInstance)
    => valueModelFromDeclaration(declaration, containerInstance).type.subtypeOf(`NoOp`);

Anything() functionModelToFunction(Function<Anything,[]> func) => () => func.apply();

[String*] buildDependencies(
    FunctionOrValueDeclaration declaration,
    Map<FunctionOrValueDeclaration,FunctionOrValueDeclaration[]> phases) => concatenate( {
        for (dependsOnAnnotation in declaration.annotations<DependsOnAnnotation>())
        for (dependency in dependsOnAnnotation.dependencies)
        goalName(goalAnnotation(dependency), dependency)
    }, {
        for (dependency in phases.get(declaration) else [])
        goalName(goalAnnotation(dependency), dependency)
    }
);

