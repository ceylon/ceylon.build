"Group of goals that can be run at once"
shared class GoalGroup(name, goals) satisfies Named & Identifiable {
    
    shared actual String name;
    
    shared {<Goal|GoalGroup>+} goals;
    
    string => "``name`` ``goals``";
    
    hash => name.hash;
    
    shared actual Boolean equals(Object that) {
        if (is GoalGroup that) {
            return that.name == name;
        }
        return false;
    }
}

