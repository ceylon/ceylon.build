shared interface Task {
    
    shared formal String name;
    
    shared formal void process();
    
    shared default String help() => "";
    
    string => name;
}

shared alias TasksDefinitions => Map<Task, [Task*]>;

shared object clean satisfies Task {
    name = "clean";
    shared actual void process() {
        print("cleaning");
    }
}

shared object compile satisfies Task {
    name = "compile";
    shared actual void process() {
        print("compiling");
    }
}