import ceylon.process { Process, createProcess, currentOutput, currentError }
shared interface Task satisfies Identifiable {
    
    shared formal String name;
    
    shared formal void process(String[] arguments);
    
    shared default String help() => "";
    
    string => name;
    
    hash => name.hash;
    
    shared actual Boolean equals(Object that) {
        if (is Task that) {
            return that.name == name;
        }
        return false;
    }
}

shared object clean satisfies Task {
    name = "clean";
    shared actual void process(String[] arguments) {
        print("cleaning");
    }
}

shared Task createCompileTask(String moduleName) {
    object compile satisfies Task {
        name = "compile";
        shared actual void process(String[] arguments) {
            String cmd = "ceylon compile ``moduleName``";
            print("compiling: ``cmd``");
            Process process = createProcess {
                command = cmd;
                //command = "ls --tata";
                output = currentOutput;
                error = currentError;
            };
            process.waitForExit();
        }
    }
    return compile; 
}
