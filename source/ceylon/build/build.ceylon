import ceylon.collection { HashMap }

shared alias TasksDefinitions => {Entry<Task, {Task*}>*};
shared alias TasksDefinitionsMap => Map<Task, {Task*}>;

shared interface Writer {
    shared formal void info(String message);
    shared formal void error(String message);
    shared default void exception(Exception exception) => error(exception.message);
}

object consoleWriter satisfies Writer {
    
    shared actual void error(String message) {
        print(message);
    }
    
    shared actual void info(String message) {
        process.writeErrorLine(message);
    }
    shared actual void exception(Exception exception) {
        exception.printStackTrace();
    }
}

shared void build(TasksDefinitions tasksDefinitions) {
    buildTasks(HashMap<Task, {Task*}>(tasksDefinitions), consoleWriter);
}

shared void buildTasks(TasksDefinitionsMap tasks, Writer writer) {
    writer.info("## ceylon.build");
    value cycles = analyzeDependencyCycles(tasks);
    if (cycles.empty) {
        value tasksToRun = buildTaskExecutionList(tasks, process.arguments, writer);
        runTasks(tasksToRun, process.arguments, tasks.keys, writer);
    } else {
        writer.error("# task dependency cycle found between: ``cycles``");
    }
}