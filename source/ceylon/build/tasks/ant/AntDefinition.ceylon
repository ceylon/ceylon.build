"""
   Ant introspection works from top down, as the implementing classes of Ant types change depending on their location in the XML hierarchy.
   
   Example:
   
   ```ceylon
   AntProject antProject = currentAntProject();
   AntDefinition? copyAntDefinition = antProject.topLevelAntDefinition(\"copy\");
   assert(exists copyAntDefinition);
   AntDefinition? filesetAntDefinition = copyAntDefinition.nestedElementDefinition(\"fileset\");
   assert(exists filesetAntDefinition);
   AntDefinition? includeAntDefinition = filesetAntDefinition.nestedElementDefinition(\"include\");
   assert(exists includeAntDefinition);
   ```
"""
shared interface AntDefinition satisfies Comparable<AntDefinition> {
    shared formal String antName;
    shared formal String elementTypeClassName;
    shared formal List<AntAttributeDefinition> attributes();
    shared formal List<AntDefinition> nestedAntDefinitions();
    shared formal Boolean isTask();
    shared formal Boolean isDataType();
    shared formal Boolean isTextSupported();
    shared formal Boolean acceptsDynamicNestedElements();
    shared formal Boolean isContainer();
}

shared class AntAttributeDefinition(name, className) {
	shared String name;
	shared String className;
}
