import ceylon.language.meta { type }
import ceylon.language.meta.declaration { Module, FunctionDeclaration, ValueDeclaration, FunctionOrValueDeclaration, ClassDeclaration }
import ceylon.language.meta.model { Value, Function, Type }
import ceylon.build.engine { GoalProperties, GoalDefinitionsBuilder, Goal }
import ceylon.build.task { GoalAnnotation, Task, IncludeAnnotation, Context, done, Outcome }

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

shared [FunctionOrValueDeclaration*] findPackageMembersAnnotatedWithGoals(Module mod) {
    value annotatedGoals = SequenceBuilder<FunctionOrValueDeclaration>();
    for (pkg in mod.members) {
        annotatedGoals.appendAll(pkg.annotatedMembers<FunctionDeclaration, GoalAnnotation>());
        annotatedGoals.appendAll(pkg.annotatedMembers<ValueDeclaration, GoalAnnotation>());
    }
    return annotatedGoals.sequence;
}

Goal|InvalidGoalDeclaration goalDefinition(FunctionOrValueDeclaration declaration, Object? container = null) {
    value annotation = goalAnnotation(declaration);
    value name = goalName(annotation, declaration);
    value tasks = extractTasks(declaration, container);
    if (exists tasks) {
        return Goal(name, GoalProperties(annotation.internal, tasks, annotation.dependencies));
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

{Task*}? extractTasks(FunctionOrValueDeclaration declaration, Object? container = null) {
    switch (declaration)
    case (is ValueDeclaration) {
        value valueModel = valueFromDeclaration(declaration, container);
        if (isTaskImport(valueModel)) {
            return tasksFromTaskImport(valueModel);
        } else if (isTasksImport(valueModel)) {
            return tasksFromTasksImport(valueModel);
        }
    } case (is FunctionDeclaration) {
        value func = functionFromDeclaration(declaration, container);
        if (isVoidWithNoParametersFunction(func)) {
            return tasksFromFunction(func);
        } else if (isTaskFunction(func)) {
            return tasksFromTaskFunction(func);
        }
    }
    return null;
}

Value valueFromDeclaration(ValueDeclaration valueDeclaration, Anything containerInstance) {
    if (exists containerInstance) {
        value containerType = type(containerInstance);
        assert(exists attribute = containerType.getAttribute<Nothing, Anything>(valueDeclaration.name));
        return attribute.bind(containerInstance);
    }
    return valueDeclaration.apply<Anything>();
}

Function<Anything, Nothing> functionFromDeclaration(
    FunctionDeclaration declaration, Object? containerInstance) {
    if (exists containerInstance) {
        value containerType = type(containerInstance);
        assert(exists method = containerType.getMethod<Nothing, Anything, Nothing>(declaration.name));
        return method.bind(containerInstance);
    }
    return declaration.apply<Anything, Nothing>();
}

shared Boolean isTaskImport(Value<Anything,Nothing> val) {
    return val.type.subtypeOf(`Task`);
}

shared Boolean isTasksImport(Value<Anything,Nothing> val) {
    return val.type.subtypeOf(`{Task*}`);
}

shared Boolean isVoidWithNoParametersFunction(Function<Anything,Nothing> func) {
    return func.type.exactly(`Anything`) && func.parameterTypes.empty;
}

shared Boolean isTaskFunction(Function<Anything, Nothing> func) {
    return func.type.subtypeOf(`Outcome`) &&
            func.parameterTypes.every((Type<Anything> type) => type.subtypeOf(`Context`));
}

shared {Task*} tasksFromTaskImport(Value<Anything,Nothing> val) {
    {Task*} holder() {
        assert(is Task task = val.get());
        return { task };
    }
    return deferredTasks(holder);
}

shared {Task*} tasksFromTasksImport(Value<Anything,Nothing> val) {
    {Task*} holder() {
        assert(is {Task*} task = val.get());
        return task;
    }
    return deferredTasks(holder);
}

shared {Task*} tasksFromFunction(Function<Anything,Nothing> func) {
    return {
        function(Context context) {
            func.apply();
            return done;
        }
    };
}

shared {Task*} tasksFromTaskFunction(Function<Anything, Nothing> func) {
    return {
        function(Context context) {
            assert(is Outcome outcome = func.apply(context));
            return outcome;
        }
    };
}

shared {Task*} deferredTasks({Task*}() holder) {
    object deferredTasks satisfies {Task*} {
        
        variable {Task*}? _tasks = null;
        
        {Task*} tasks {
            if (!_tasks exists) {
                _tasks = holder();
            }
            assert(exists tasks = _tasks);
            return tasks;
        }
        
        iterator() => tasks.iterator();
    }
    return deferredTasks;
}

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

FunctionOrValueDeclaration[] findClassMembersAnnotatedWithGoal(
        ClassDeclaration instanceTypeDeclaration) {
    value functionDeclarations = instanceTypeDeclaration.
            annotatedDeclaredMemberDeclarations<FunctionDeclaration, GoalAnnotation>();
    value valuesDeclarations = instanceTypeDeclaration.
            annotatedDeclaredMemberDeclarations<ValueDeclaration, GoalAnnotation>();
    return concatenate(functionDeclarations, valuesDeclarations);
}

class InvalidGoalDeclaration(declaration) {
    shared FunctionOrValueDeclaration declaration;
}
