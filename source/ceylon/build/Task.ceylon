shared interface Task satisfies Identifiable {
    
    shared formal String name;
    
    shared formal Boolean process(String[] arguments, Writer writer);
    
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

shared Task createTask(String taskName, Boolean method(String[] arguments, Writer writer)) {
    object task satisfies Task {
        name = taskName;
        process = method;  
    }
    return task;
}
