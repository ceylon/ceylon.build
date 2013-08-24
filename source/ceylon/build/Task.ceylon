shared class Context(arguments, writer) {
    
    shared {String*} arguments;
    
    shared Writer writer;
}

shared alias TaskDefinition => Boolean(Context);

shared class Task(name, process, dependencies = []) satisfies Identifiable {
    
    shared String name;
    
    shared TaskDefinition process;
    
    shared {Task*} dependencies;
    
    string => name;
    
    hash => name.hash;
    
    shared actual Boolean equals(Object that) {
        if (is Task that) {
            return that.name == name;
        }
        return false;
    }
}
