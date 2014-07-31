package ceylon.build.tasks.ant.internal;

import java.util.List;

public class AntDefinitionSupport {
    
    private Gateway gateway;
    private Object sealedAntDefinition;
    
    AntDefinitionSupport(Gateway gateway, Object sealedAntDefinition) {
        this.gateway = gateway;
        this.sealedAntDefinition = sealedAntDefinition;
    }
    
    public void fillAttributeList(ceylon.collection.LinkedList<AntAttributeDefinitionSupport> result) {
        @SuppressWarnings("unchecked")
        List<String[]> attributeDefinitions = (List<String[]>) gateway.invoke(sealedAntDefinition, "getAttributeDefinitions");
        for(String[] attributeDefinition : attributeDefinitions) {
            String attributeName = attributeDefinition[0];
            String className = attributeDefinition[1];
            AntAttributeDefinitionSupport antAttributeDefinitionSupport = new AntAttributeDefinitionSupport(attributeName, className);
            result.add(antAttributeDefinitionSupport);
        }
    }
    
    public void fillNestedAntDefinitionList(ceylon.collection.LinkedList<AntDefinitionSupport> result) {
        @SuppressWarnings("unchecked")
        List<Object> nestedSealedAntDefinitions = (List<Object>) gateway.invoke(sealedAntDefinition, "getNestedAntDefinitions");
        for(Object nestedSealedAntDefinition : nestedSealedAntDefinitions) {
            AntDefinitionSupport antAttributeDefinitionSupport = new AntDefinitionSupport(gateway, nestedSealedAntDefinition);
            result.add(antAttributeDefinitionSupport);
        }
    }
    
    public String getAntName() {
        String antName = (String) gateway.invoke(sealedAntDefinition, "getAntName");
        return antName;
    }
    
    public Class<Object> getElementType() {
        @SuppressWarnings("unchecked")
        Class<Object> elementType = (Class<Object>) gateway.invoke(sealedAntDefinition, "getElementType");
        return elementType;
    }
    
    public Class<Object> getEffectiveElementType() {
        @SuppressWarnings("unchecked")
        Class<Object> effectiveElementType = (Class<Object>) gateway.invoke(sealedAntDefinition, "getEffectiveElementType");
        return effectiveElementType;
    }
    
    public boolean isTask() {
        Boolean isTask = (Boolean) gateway.invoke(sealedAntDefinition, "isTask");
        return isTask;
    }
    
    public boolean isDataType() {
        Boolean isDataType = (Boolean) gateway.invoke(sealedAntDefinition, "isDataType");
        return isDataType;
    }
    
    public boolean isTextSupported() {
        Boolean isTextSupported = (Boolean) gateway.invoke(sealedAntDefinition, "isTextSupported");
        return isTextSupported;
    }
    
    public boolean acceptsArbitraryNestedElementsOrAttributes() {
        Boolean acceptsArbitraryNestedElementsOrAttributes = (Boolean) gateway.invoke(sealedAntDefinition, "acceptsArbitraryNestedElementsOrAttributes");
        return acceptsArbitraryNestedElementsOrAttributes;
    }
    
    public boolean isContainer() {
        Boolean isContainer = (Boolean) gateway.invoke(sealedAntDefinition, "isContainer");
        return isContainer;
    }
    
}
