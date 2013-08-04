import ceylon.process { Process, createProcess, currentOutput, currentError }

shared interface Task satisfies Identifiable {
    
    shared formal String name;
    
    shared formal void process(String[] arguments, Writer writer);
    
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

shared Task createTask(String taskName, void method(String[] arguments, Writer writer)) {
    object task satisfies Task {
        name = taskName;
        process = method;  
    }
    return task;
}

shared Task createCompileTask(String moduleName) {
    object compile satisfies Task {
        name = "compile";
        shared actual void process(String[] arguments, Writer writer) {
            String cmd = "ceylon compile ``moduleName`` ``" ".join(arguments)``";
            print("compiling: ``cmd``");
            Process process = createProcess {
                command = cmd;
                output = currentOutput;
                error = currentError;
            };
            process.waitForExit();
        }
    }
    return compile; 
}
