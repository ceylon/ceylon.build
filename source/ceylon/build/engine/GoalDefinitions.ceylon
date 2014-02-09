import ceylon.collection { HashMap }

shared class GoalDefinitions({<String->GoalProperties>*} definitions) {
    
    Map<String, GoalProperties> map = HashMap { entries = definitions; };
    
    value stringSort = (String a, String b) => a.compare(b);
    
    shared [String*] availableGoals =
        [ for (definition in definitions)
            if (!definition.item.internal)
                definition.key ].sort(stringSort);
    
    shared [String*] internalGoals =
        [ for (definition in definitions)
            if (definition.item.internal)
                definition.key ].sort(stringSort);
    
    shared Boolean defines(String goal) => map.defines(goal);
    
    shared GoalProperties properties(String goal) {
        "No goal defined with given name"
        assert(exists propeties = map.get(goal));
        return propeties;
    }
}
