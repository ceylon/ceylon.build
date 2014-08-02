import ceylon.build.tasks.ant.internal {
    Gateway
}
import ceylon.collection {
    ArrayList
}
import java.util {
    JList=List
}
import java.lang {
    ObjectArray
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

class AntDefinitionImplementation(Gateway gateway, Object sealedAntDefinition) satisfies AntDefinition {
    
    shared actual String antName = toString(gateway.invoke(sealedAntDefinition, "getAntName"));
    shared actual String elementTypeClassName = toString(gateway.invoke(sealedAntDefinition, "getElementType"));
    shared actual String effectiveElementTypeClassName = toString(gateway.invoke(sealedAntDefinition, "getEffectiveElementType"));
    shared actual Boolean implementationWrapped = elementTypeClassName != effectiveElementTypeClassName;
    
    shared actual List<AntAttributeDefinition> attributes() {
        Anything attributeDefinitions = gateway.invoke(sealedAntDefinition, "getAttributeDefinitions");
        "Java List of Java String Array expected."
        assert(is JList<out Anything> attributeDefinitions);
        ArrayList<AntAttributeDefinition> antAttributeDefinitions = ArrayList<AntAttributeDefinition>();
        value jIterator = attributeDefinitions.iterator();
        while (jIterator.hasNext()){
            Anything attributeDefinition = jIterator.next();
            "Java Array of Strings expected."
            assert(is ObjectArray<Anything> attributeDefinition);
            String name = toString(attributeDefinition.get(0));
            String className = toString(attributeDefinition.get(1));
            AntAttributeDefinitionImplementation antAttributeDefinitionImplementation = AntAttributeDefinitionImplementation(name, className);
            antAttributeDefinitions.add(antAttributeDefinitionImplementation);
        }
        AntAttributeDefinition[] result = antAttributeDefinitions.sort(byIncreasing((AntAttributeDefinition a) => a.name));
        return result;
    }
    
    shared actual List<AntDefinition> nestedAntDefinitions() {
        Anything nestedSealedAntDefinitions = gateway.invoke(sealedAntDefinition, "getNestedAntDefinitions");
        "Java List expected."
        assert(is JList<out Anything> nestedSealedAntDefinitions);
        ArrayList<AntDefinition> nestedAntDefinitionList = ArrayList<AntDefinition>();
        value jIterator = nestedSealedAntDefinitions.iterator();
        while (jIterator.hasNext()){
            Anything nestedSealedAntDefinition = jIterator.next();
            assert(is Object nestedSealedAntDefinition);
            AntDefinition nestedAntDefinition = AntDefinitionImplementation(gateway, nestedSealedAntDefinition);
            nestedAntDefinitionList.add(nestedAntDefinition);
        }
        List<AntDefinition> result = nestedAntDefinitionList.sort(byIncreasing((AntDefinition a) => a));
        return result;
    }
    
    shared actual Boolean isTask() {
        return toBoolean(gateway.invoke(sealedAntDefinition, "isTask"));
    }
    
    shared actual Boolean isDataType() {
        return toBoolean(gateway.invoke(sealedAntDefinition, "isDataType"));
    }
    
    shared actual Boolean isTextSupported() {
        return toBoolean(gateway.invoke(sealedAntDefinition, "isTextSupported"));
    }
    
    shared actual Boolean acceptsArbitraryNestedElementsOrAttributes() {
        return toBoolean(gateway.invoke(sealedAntDefinition, "acceptsArbitraryNestedElementsOrAttributes"));
    }
    
    shared actual Boolean isContainer() {
        return toBoolean(gateway.invoke(sealedAntDefinition, "isContainer"));
    }
    
    shared actual Boolean equals(Object otherObject) {
        if(is AntDefinition otherObject) {
            return (
                (isTask() == otherObject.isTask()) &&
                (antName == otherObject.antName) && 
                (elementTypeClassName == otherObject.elementTypeClassName) &&
                (effectiveElementTypeClassName == otherObject.effectiveElementTypeClassName)
            );
        }
        return false;
    }
    
    shared actual Integer hash {
        return antName.hash + elementTypeClassName.hash + effectiveElementTypeClassName.hash;
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
        Comparison elementTypeClassNameComparision = elementTypeClassName <=> other.elementTypeClassName;
        if(elementTypeClassNameComparision != equal) {
            return elementTypeClassNameComparision;
        }
        return effectiveElementTypeClassName <=> other.effectiveElementTypeClassName;
    }
    
    shared actual String string {
        String effective = (elementTypeClassName == effectiveElementTypeClassName) then "" else "#``effectiveElementTypeClassName``";
        return "``isTask() then "AntTask" else "AntType"``: ``antName``#``elementTypeClassName````effective``";
    }
    
}
