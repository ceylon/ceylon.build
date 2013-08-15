shared class Task(name, process, dependencies = []) satisfies Identifiable {
    
    shared String name;
    
    shared Boolean process(String[] arguments, Writer writer);
    
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
