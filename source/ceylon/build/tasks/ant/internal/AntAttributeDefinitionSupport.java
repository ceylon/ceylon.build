package ceylon.build.tasks.ant.internal;

public class AntAttributeDefinitionSupport {
    
    private String attributeName;
    private String className;
    
    AntAttributeDefinitionSupport(String attributeName, String className) {
        this.attributeName = attributeName;
        this.className = className;
    }
    
    public String getName() {
        return attributeName;
    }
    
    public String getClassName() {
        return className;
    }
    
}
