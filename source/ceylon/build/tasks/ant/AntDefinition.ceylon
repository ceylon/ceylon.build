"""
   Ant type and task defintion returned by introspection (element defintion).
   Ant introspection works from top down, as the implementing classes of Ant types change depending on their location in the XML hierarchy.
   
   Example:
   
   ```
   AntProject antProject = currentAntProject();
   AntDefinition? copyAntDefinition = antProject.topLevelAntDefinition("copy");
   assert(exists copyAntDefinition);
   AntDefinition? filesetAntDefinition = copyAntDefinition.nestedElementDefinition("fileset");
   assert(exists filesetAntDefinition);
   AntDefinition? includeAntDefinition = filesetAntDefinition.nestedElementDefinition("include");
   assert(exists includeAntDefinition);
   ```
"""
shared interface AntDefinition satisfies Comparable<AntDefinition> {
    
    """
       Name of the ant type/task.
    """
    shared formal String antName;
    
    """
       Name of implementing Java class.
    """
    shared formal String elementTypeClassName;
    
    """
       Name of effective Java class, if `elementTypeClassName` is of type `org.apache.tools.ant.TypeAdapter` (or it's subtypes).
    """
    shared formal String effectiveElementTypeClassName;
    
    """
       Indicates whether the effective implementation is wrapped.
       This becomes true, when `elementTypeClassName` is of type `org.apache.tools.ant.TypeAdapter` (or it's subtypes).
    """
    shared formal Boolean implementationWrapped;
    
    """
       List of available attributes.
    """
    shared formal List<AntAttributeDefinition> attributes();
    
    """
       List of nested ant definitions (elements).
    """
    shared formal List<AntDefinition> nestedAntDefinitions();
    
    """
       Indicates whether the introspected Ant defintion is a regular Ant task that can be executed.
    """
    shared formal Boolean isTask();
    
    """
       Indicates whether the introspected Ant defintion is a data type that can appear inside the build file stand alone.
    """
    shared formal Boolean isDataType();
    
    """
       Indicates whether the introspected Ant defintion can contain text (as Ant element).
    """
    shared formal Boolean isTextSupported();
    
    """
       Indicates whether the introspected Ant defintion is a dynamic one, supporting arbitrary nested elements and/or attributes.
    """
    shared formal Boolean acceptsArbitraryNestedElementsOrAttributes();
    
    """
       Indicates whether the introspected Ant defintion is a task container, supporting arbitrary nested tasks/types.
    """
    shared formal Boolean isContainer();
    
}

"""
   Ant attribute defintion returned by introspection.
"""
shared interface AntAttributeDefinition {
    
    """
       Name of attribute.
    """
    shared formal String name;
    
    """
       Name of corresponding Java class.
    """
    shared formal String className;
    
}
