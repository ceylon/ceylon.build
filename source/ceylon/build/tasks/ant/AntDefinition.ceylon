import ceylon.build.tasks.ant.internal {
    AntAttributeDefinitionSupport,
    AntDefinitionSupport
}
import ceylon.collection {
    LinkedList
}

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

class AntDefinitionImplementation(AntDefinitionSupport antDefinitionSupport) satisfies AntDefinition {
    
    shared actual String antName = antDefinitionSupport.antName;
    shared actual String elementTypeClassName = antDefinitionSupport.elementType.name;
    shared actual String effectiveElementTypeClassName = antDefinitionSupport.effectiveElementType.name;
    shared actual Boolean implementationWrapped = antDefinitionSupport.elementType.name != antDefinitionSupport.effectiveElementType.name;
    
    shared actual List<AntAttributeDefinition> attributes() {
        LinkedList<AntAttributeDefinitionSupport> antAttributeDefinitionSupportList = LinkedList<AntAttributeDefinitionSupport>();
        antDefinitionSupport.fillAttributeList(antAttributeDefinitionSupportList);
        {AntAttributeDefinition*} antAttributeDefinitions = antAttributeDefinitionSupportList.map<AntAttributeDefinition>(
            (AntAttributeDefinitionSupport a) => AntAttributeDefinitionImplementation(a.name, a.className)
        );
        AntAttributeDefinition[] result = antAttributeDefinitions.sort(byIncreasing((AntAttributeDefinition a) => a.name));
        return result;
    }
    
    shared actual List<AntDefinition> nestedAntDefinitions() {
        LinkedList<AntDefinitionSupport> nestedAntDefinitionSupportList = LinkedList<AntDefinitionSupport>();
        antDefinitionSupport.fillNestedAntDefinitionList(nestedAntDefinitionSupportList);
        LinkedList<AntDefinition> nestedAntDefinitionList = LinkedList<AntDefinition>();
        for (nestedAntDefinitionSupport in nestedAntDefinitionSupportList) {
            AntDefinition nestedAntDefinition = AntDefinitionImplementation(nestedAntDefinitionSupport);
            nestedAntDefinitionList.add(nestedAntDefinition);
        }
        AntDefinition[] result = nestedAntDefinitionList.sort(byIncreasing((AntDefinition a) => a));
        return result;
    }
    
    shared actual Boolean isTask() {
        return antDefinitionSupport.task;
    }
    
    shared actual Boolean isDataType() {
        return antDefinitionSupport.dataType;
    }
    
    shared actual Boolean isTextSupported() {
        return antDefinitionSupport.textSupported;
    }
    
    shared actual Boolean acceptsArbitraryNestedElementsOrAttributes() {
        return antDefinitionSupport.acceptsArbitraryNestedElementsOrAttributes();
    }
    
    shared actual Boolean isContainer() {
        return antDefinitionSupport.container;
    }
    
    shared actual Boolean equals(Object otherObject) {
        if(is AntDefinition otherObject) {
            return ((isTask() == otherObject.isTask()) && antName == otherObject.antName) && (elementTypeClassName == otherObject.elementTypeClassName);
        }
        return false;
    }
    
    shared actual Integer hash {
        return antName.hash + elementTypeClassName.hash;
    }
    
    shared actual Comparison compare(AntDefinition other) {
        if(isTask() && !other.isTask()) {
            return larger;
        }
        if(!isTask() && other.isTask()) {
            return smaller;
        }
        Comparison nameComparision = antName <=> other.antName;
        if(nameComparision != equal) {
            return nameComparision;
        }
        return elementTypeClassName <=> other.elementTypeClassName;
    }
    
    shared actual String string {
        return "``isTask() then "AntTask" else "AntType"``: ``antName``#``elementTypeClassName``";
    }
    
}
