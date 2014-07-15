import ceylon.build.tasks.ant { AntDefinition, AntAttributeDefinition }
import ceylon.collection { LinkedList }

shared class AntDefinitionImplementation(AntDefinitionSupport antDefinitionSupport) satisfies AntDefinition {
    
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

shared class AntAttributeDefinitionImplementation(name, className) satisfies AntAttributeDefinition {
    shared actual String name;
    shared actual String className;
}
