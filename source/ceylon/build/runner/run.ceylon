import ceylon.language.meta { modules }
import ceylon.language.meta.declaration { FunctionDeclaration, Module }
import ceylon.language.meta.model { IncompatibleTypeException, TypeApplicationException, Function }
import ceylon.build.task { Goal, Task, GoalAnnotation }
import org.jboss.modules {
    JBossModule = Module { ceylonModuleLoader = callerModuleLoader },
    ModuleIdentifier { createModuleIdentifier = create }
}
import ceylon.build.engine { runEngine }

shared void run() {
    value arguments = process.arguments;
    "module should be provided"
    assert(exists name = arguments[0]);
    Module? mod = loadModule(name);
    if (exists mod) {
        value annotatedGoals = findAnnotatedGoals(mod);
        value goalsBuilder = SequenceBuilder<Goal>();
        for (functionDeclaration in annotatedGoals) {
            value goal = createGoal(functionDeclaration);
            goalsBuilder.append(goal);
        }
        value goals = goalsBuilder.sequence;
        "No goals found"
        assert(nonempty goals);
        runEngine {
            goals = goals;
            arguments =  arguments[1...];
        };
    } else {
        process.writeErrorLine("not found ``name``");
    }
}

Module? loadModule(String moduleArgument) {
    String moduleName;
    String moduleVersion;
    if (exists i = moduleArgument.firstInclusion("/")) {
        moduleName = moduleArgument[0..i-1];
        moduleVersion = moduleArgument[i+1...];
    } else {
        moduleName = moduleArgument;
        moduleVersion = "";
    }
    loadModuleInClassPath(moduleName, moduleVersion);
    return modules.find(moduleName, moduleVersion);
}

void loadModuleInClassPath(String modName, String modVersion) {
    value modIdentifier = createModuleIdentifier(modName, modVersion);
    value mod = ceylonModuleLoader.loadModule(modIdentifier);
    value modClassLoader = mod.classLoader;
    value classToLoad = "``modName``.module_";
    modClassLoader.loadClass(classToLoad);
}

[FunctionDeclaration*] findAnnotatedGoals(Module mod) {
    value annotatedGoals = SequenceBuilder<FunctionDeclaration>();
    for (pkg in mod.members) {
        value goalsFromPackage = pkg.annotatedMembers<FunctionDeclaration, GoalAnnotation>();
        annotatedGoals.appendAll(goalsFromPackage);
    }
    return annotatedGoals.sequence;
}

Goal createGoal(FunctionDeclaration declaration) {
    value annotation = goalAnnotation(declaration);
    value name = goalName(annotation, declaration);
    value holder = tasksHolder(name, declaration);
    return Goal(name, tasks(holder));
}

GoalAnnotation goalAnnotation(FunctionDeclaration declaration) {
    value goalAnnotations = declaration.annotations<GoalAnnotation>();
    assert (nonempty goalAnnotations, goalAnnotations.size == 1);
    return goalAnnotations.first;
}

String goalName(GoalAnnotation annotation, FunctionDeclaration declaration) {
    if (annotation.name.empty) {
        return declaration.name;
    }
    return annotation.name;
}

Function<Task|{Task*},[]> tasksHolder(String goalName, FunctionDeclaration declaration) {
    try {
        return declaration.apply<Task|{Task*}, []>();
    } catch (IncompatibleTypeException|TypeApplicationException e) {
        value parametersTypeNames = { for (f in declaration.parameterDeclarations) f.openType.string };
        throw AssertionException(
            "Unsupported signature for goal '``goalName``' (```declaration.string```)
             found: ```declaration.openType``(``", ".join(parametersTypeNames)``)`
             expected: one of the following
              - `Task()`: A task
              - `{Task*}()`: A list of tasks
              - `Anything`: a simple function");
    }
}

{Task*} tasks(Function<Task|{Task*}, []> holder) {
    object deferredTasks satisfies {Task*} {
        shared actual Iterator<Task> iterator() {
            Task|{Task*} tasks = holder();
            if (is Task tasks) {
                return {tasks}.iterator();
            }
            else if (is {Task*} tasks) {
                return tasks.iterator();
            } else {
                throw AssertionException(
                    "!!BUG!!: Invalid task type.
                     Please report it here: https://github.com/ceylon/ceylon.build/issues/new");
            }
        }
    }
    return deferredTasks;
}