import ceylon.language.meta { type }
import ceylon.language.meta.declaration { FunctionDeclaration, Module, ValueDeclaration, OpenClassType }
import ceylon.build.engine { GoalProperties, GoalDefinitionsBuilder, Goal }
import ceylon.build.task { GoalAnnotation, Task, IncludeAnnotation }

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

Goal goalDefinition(FunctionDeclaration declaration, Object()? container = null) {
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

<Task|{Task*}>() tasksHolder(FunctionDeclaration declaration, Object()? container = null) {
    return function() {
        Anything result;
        if (exists container) {
            result = declaration.memberInvoke(container());
        } else {
            result = declaration.invoke();
        }
        if (is Task|{Task*} result) {
            return result;
        } else {
            throw unsupportedSignature(declaration);
        }
    };
}

{Task*} tasks(<Task|{Task*}>() holder) {
    object deferredTasks satisfies {Task*} {
        
        variable {Task*}? _tasks = null;
        
        shared {Task*} tasks {
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
    variable Object? _instance = null;
    function instance() {
        if (!_instance exists) {
            value model = declaration.apply<Object>();
            _instance = model.get();
        }
        assert(exists instance = _instance);
        return instance;
    }
    
    value goals = SequenceBuilder<Goal>();
    value openType = declaration.openType;
    switch (openType)
    case (is OpenClassType) {
        value declarations = openType.declaration.annotatedDeclaredMemberDeclarations<FunctionDeclaration, GoalAnnotation>();
        for (goalDeclaration in declarations) {
            goals.append(goalDefinition(goalDeclaration, instance));
        }
    } else {
        throw AssertionException(
            "Invalid return type for `include` annotated function ```declaration.name```.
             Return type should be a class.
             found: ``openType``
             type: ``type(openType)``");
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

AssertionException unsupportedSignature(FunctionDeclaration declaration) {
    value parametersTypeNames = { for (f in declaration.parameterDeclarations) f.openType.string };
    return AssertionException(
        "Unsupported signature for goal annotated function ```declaration.name```
         found: ```declaration.openType``(``", ".join(parametersTypeNames)``)`
         expected: one of the following
         - `Task()`: A task
         - `{Task*}()`: A list of tasks");
         //- `Anything`: a simple function");
}