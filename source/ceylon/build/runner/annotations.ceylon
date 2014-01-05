import ceylon.language.meta { type }
import ceylon.language.meta.declaration { Module, FunctionDeclaration, ValueDeclaration, OpenClassOrInterfaceType }
import ceylon.build.engine { GoalProperties, GoalDefinitionsBuilder, Goal }
import ceylon.build.task { GoalAnnotation, Task, IncludeAnnotation, Context, done, Outcome, Success, Failure }

GoalDefinitionsBuilder readAnnotations(Module mod) {
    value goals = GoalDefinitionsBuilder();
    for (declaration in findAnnotatedGoals(mod)) {
        goals.add(goalDefinition(declaration));
    }
    for (declaration in findAnnotatedIncludes(mod)) {
        for (goal in goalsDefinition(declaration)) {
            goals.add(goal);
        }
    }
    return goals;
}

shared [FunctionDeclaration*] findAnnotatedGoals(Module mod) {
    value annotatedGoals = SequenceBuilder<FunctionDeclaration>();
    for (pkg in mod.members) {
        value goalsFromPackage = pkg.annotatedMembers<FunctionDeclaration, GoalAnnotation>();
        annotatedGoals.appendAll(goalsFromPackage);
    }
    return annotatedGoals.sequence;
}

Goal goalDefinition(FunctionDeclaration declaration, Object? container = null) {
    value annotation = goalAnnotation(declaration);
    value name = goalName(annotation, declaration);
    value tasks = extractTasks(declaration, container);
    return Goal(name, GoalProperties(annotation.internal, tasks, annotation.dependencies));
}

"Returns `GoalAnnotation` associated to this declaration"
throws(`class AssertionException`, "When no `GoalAnnotation` is found on this declaration")
shared GoalAnnotation goalAnnotation(FunctionDeclaration declaration) {
    value annotations = declaration.annotations<GoalAnnotation>();
    assert (nonempty annotations, annotations.size == 1);
    return annotations.first;
}

shared String goalName(GoalAnnotation annotation, FunctionDeclaration declaration) {
    return annotation.name.empty then declaration.name else annotation.name;
}

Anything invoke(FunctionDeclaration declaration, Object? container, Anything* arguments) {
    Anything result;
    if (exists container) {
        result = declaration.memberInvoke(container, [], *arguments);
    } else {
        result = declaration.invoke([], *arguments);
    }
    return result;
}

{Task*} extractTasks(FunctionDeclaration declaration, Object? container = null) {
    if (!declaration.typeParameterDeclarations.empty) {
        throw unsupportedSignature("Function should not have type parameters", declaration);
    }
    if (!declaration.openType is OpenClassOrInterfaceType ) {
        throw unsupportedSignature("Invalid return type", declaration);
    }
    assert(is OpenClassOrInterfaceType openType = declaration.openType);
    if (isVoidWithNoParametersFunction(declaration, openType)) {
        return tasksFromFunction(declaration, container);
    } else if (isTaskFunction(declaration, openType)) {
        return tasksFromTaskFunction(declaration, container);
    } else if (isTaskDelegateFunction(declaration)) {
        return tasksFromTaskDelegate(declaration, container);
    }  if (isTasksDelegateFunction(declaration)) {
        return tasksFromTasksDelegate(declaration, container);
    } else {
        throw unsupportedSignature("Invalid signature", declaration);
    }
}

shared Boolean isVoidWithNoParametersFunction(FunctionDeclaration declaration, OpenClassOrInterfaceType returnOpenType) {
    return returnOpenType.declaration == `class Anything` && declaration.parameterDeclarations.empty;
}

shared Boolean isTaskFunction(FunctionDeclaration declaration, OpenClassOrInterfaceType returnOpenType) {
     if (nonempty params = declaration.parameterDeclarations,
            is OpenClassOrInterfaceType firstParamOpenType = params.first.openType) {
        Boolean returnType = returnOpenType.declaration in [`class Outcome`, `class Success`, `class Failure`];
        Boolean argumentsType = params.size == 1 && firstParamOpenType.declaration == `class Context`;
        return returnType && argumentsType;
    }
    return false;
}

// TODO doesn't work with `Outcome(Context)` subtypes like `Success(Context)` and `Failure(Context)`, ...
shared Boolean isTaskDelegateFunction(FunctionDeclaration declaration) {
    Boolean returnType = declaration.openType == `alias Task`.openType;
    Boolean argumentsType = declaration.parameterDeclarations.empty;
    return returnType && argumentsType;
}

{Task*} tasks() { throw; }

// TODO Doesn't work for `{Task*}` subtypes like `{Task+}`,`[Task*]`,`[Task+]`, ...
shared Boolean isTasksDelegateFunction(FunctionDeclaration declaration) {
    value expectedType = `function tasks`;
    value expectedOpenType = expectedType.openType;
    value declarationOpenType = declaration.openType;
    Boolean returnType = declarationOpenType == expectedOpenType;
    Boolean argumentsType = declaration.parameterDeclarations.empty;
    return returnType && argumentsType;
}

shared {Task*} tasksFromFunction(FunctionDeclaration declaration, Object? container) {
    return {
        function(Context context) {
            invoke(declaration, container);
            return done;
        }
    };
}

shared {Task*} tasksFromTaskFunction(FunctionDeclaration declaration, Object? container) {
    return {
        function(Context context) {
            assert(is Outcome outcome = invoke(declaration, container, context));
            return outcome;
        }
    };
}

shared {Task*} tasksFromTaskDelegate(FunctionDeclaration declaration, Object? container) {
    {Task*} holder() {
        assert(is Task task = invoke(declaration, container));
        return { task };
    }
    return deferredTasks(holder);
}

shared {Task*} tasksFromTasksDelegate(FunctionDeclaration declaration, Object? container) {
    {Task*} holder() {
        assert(is {Task*} task = invoke(declaration, container));
        return task;
    }
    return deferredTasks(holder);
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

{Goal*} goalsDefinition(ValueDeclaration declaration) {
    value instance = declaration.apply<Object>().get();
    value instanceTypeDeclaration = type(instance).declaration;
    value goals = SequenceBuilder<Goal>();
    value declarations = instanceTypeDeclaration.
            annotatedDeclaredMemberDeclarations<FunctionDeclaration, GoalAnnotation>();
    for (goalDeclaration in declarations) {
        goals.append(goalDefinition(goalDeclaration, instance));
    }
    return goals.sequence;
}

AssertionException unsupportedSignature(String message, FunctionDeclaration declaration) {
    value parametersTypeNames = { for (f in declaration.parameterDeclarations) f.openType.string };
    return AssertionException(
        "Unsupported signature for goal annotated function ```declaration.name```
         ``message``
         found: ```declaration.openType``(``", ".join(parametersTypeNames)``)`
         expected: one of the following
         - `Outcome(Context)`: a simple task function
         - `Task()`: A function that returns a task
         - `{Task*}()`: A function that returns a list of tasks
         - `void()`: a simple function");
}
