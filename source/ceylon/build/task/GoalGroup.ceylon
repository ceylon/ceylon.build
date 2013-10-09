"Group of goals that can be run at once"
shared class GoalGroup(name, goals) satisfies Named {
    
    shared actual String name;
    
    shared {<Goal|GoalGroup>+} goals;
    
    string => "``name``:``goals``";
}

