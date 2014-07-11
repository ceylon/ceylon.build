
shared final class Goal(name, properties) {
    
    "Goal's name"
    shared String name;
    
    "Goal's properties"
    shared GoalProperties properties;
    
    string => "[name: ``name````!properties.dependencies.empty then
        ", dependencies: ``properties.dependencies``" else ""``]";
}
