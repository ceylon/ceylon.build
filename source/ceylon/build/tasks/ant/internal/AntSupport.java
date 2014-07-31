package ceylon.build.tasks.ant.internal;

public class AntSupport {
    
    private Gateway gateway;
    private Object sealedAnt;
    
    AntSupport(Gateway gateway, Object sealedAnt) {
        this.gateway = gateway;
        this.sealedAnt = sealedAnt;
    }
    
    public void attribute(String name, String value) {
        gateway.invoke(sealedAnt, "attribute", name, value);
    }
    
    public void element(AntSupport element) {
        gateway.invoke(sealedAnt, "element", element.sealedAnt);
    }
    
    public void setText(String text) {
        gateway.invoke(sealedAnt, "setText", text);
    }
    
    public AntSupport createNestedElement(String nestedElementName) {
        Object nestedSealedAnt = gateway.invoke(sealedAnt, "createNestedElement", nestedElementName);
        AntSupport antSupport = new AntSupport(gateway, nestedSealedAnt);
        return antSupport;
    }
    
    public void execute() {
        gateway.invoke(sealedAnt, "execute");
    }
    
    public String toString() {
        return sealedAnt.toString();
    }
    
}

