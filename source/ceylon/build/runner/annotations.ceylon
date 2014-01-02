import ceylon.language.meta { type }
import ceylon.language.meta.declaration { FunctionDeclaration, Module, ValueDeclaration, OpenClassType, OpenClassOrInterfaceType }
import ceylon.build.engine { GoalProperties, GoalDefinitionsBuilder, Goal }
import ceylon.build.task { GoalAnnotation, Task, IncludeAnnotation, Context, done, Outcome, Success, Failure }
import ceylon.language.meta.model { Type, FunctionModel, Function }

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

[FunctionDeclaration*] findAnnotatedGoals(Module mod) {
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
    value holder = tasksHolder(declaration, container);
    return Goal(name, GoalProperties(annotation.internal, tasks(holder), annotation.dependencies));
}

GoalAnnotation goalAnnotation(FunctionDeclaration declaration) {
    value annotations = declaration.annotations<GoalAnnotation>();
    assert (nonempty annotations, annotations.size == 1);
    return annotations.first;
}

String goalName(GoalAnnotation annotation, FunctionDeclaration declaration) {
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

Boolean isVoidWithNoParametersFunction(FunctionDeclaration declaration, OpenClassOrInterfaceType returnOpenType) {
    return returnOpenType.declaration == `class Anything` && declaration.parameterDeclarations.empty;
}

Boolean isTaskFunction(FunctionDeclaration declaration, OpenClassOrInterfaceType returnOpenType) {
     if (nonempty params = declaration.parameterDeclarations,
            is OpenClassOrInterfaceType firstParamOpenType = params.first.openType) {
        Boolean returnType = returnOpenType.declaration in [`class Outcome`, `class Success`, `class Failure`];
        Boolean argumentsType = params.size == 1 && firstParamOpenType.declaration == `class Context`;
        return returnType && argumentsType;
    }
    return false;
}

Boolean isTaskOrTasksDelegateFunction(FunctionDeclaration declaration, OpenClassOrInterfaceType returnOpenType) {
    return declaration.parameterDeclarations.empty;
}

<Task|{Task*}>() tasksHolder(FunctionDeclaration declaration, Object? container = null) {
    if (!declaration.typeParameterDeclarations.empty) {
        throw unsupportedSignature("Function should not have type parameters", declaration);
    }
    if (!declaration.openType is OpenClassOrInterfaceType ) {
        throw unsupportedSignature("Invalid return type", declaration);
    }
    assert(is OpenClassOrInterfaceType openType = declaration.openType);
    if (isVoidWithNoParametersFunction(declaration, openType)) {
        return function() {
            return function(Context context) {
                invoke(declaration, container);
                return done;
            };
        };
    } else if (isTaskFunction(declaration, openType)) {
        return function() {
            return function(Context context) {
                assert(is Outcome outcome = invoke(declaration, container, context));
                return outcome;
            };
        };
    } else if (isTaskOrTasksDelegateFunction(declaration, openType)) {
        return function() {
            value result = invoke(declaration, container);
            if (is Task|{Task*} result) {
                return result;
            } else {
                throw unsupportedSignature("Invalid return type", declaration);
            }
        };
    } else {
        throw unsupportedSignature("Invalid signature", declaration);
    }
}

{Task*} tasks(<Task|{Task*}>() holder) {
    object deferredTasks satisfies {Task*} {
        
        variable {Task*}? _tasks = null;
        
        {Task*} tasks {
            if (!_tasks exists) {
                Task|{Task*} taskOrtasks = holder();
                if (is Task taskOrtasks) {
                    _tasks = {taskOrtasks};
                }
                else if (is {Task*} taskOrtasks) {
                    _tasks = taskOrtasks;
                } else {
                    throw AssertionException(
                        "!!BUG!!: Invalid task type.
                         Please report it here: https://github.com/ceylon/ceylon.build/issues/new");
                }   
            }
            assert(exists tasks = _tasks);
            return tasks;
        }
        
        iterator() => tasks.iterator();
    }
    return deferredTasks;
}

[ValueDeclaration*] findAnnotatedIncludes(Module mod) {
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

<Task|{Task*}>() containedTasksHolder(Object() instance, FunctionDeclaration declaration) {
    return function() {
        value result = declaration.memberInvoke(instance());
        assert(is Task|{Task*} result);
        return result;
    };
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
