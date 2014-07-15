package ceylon.build.tasks.ant.internal;

public class AntAttributeDefinitionSupport {
    
    private String attributeName;
    private Class<?> attributeClass;
    
    public AntAttributeDefinitionSupport(String attributeName, Class<?> attributeClass) {
        this.attributeName = attributeName;
        this.attributeClass = attributeClass;
    }
    
    public String getName() {
        return attributeName;
    }
    
    public String getClassName() {
        return attributeClass.getName();
    }
    
}
