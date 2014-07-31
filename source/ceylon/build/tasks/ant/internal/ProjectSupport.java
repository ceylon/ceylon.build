package ceylon.build.tasks.ant.internal;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import java.util.Map;

public class ProjectSupport {
    
    private Gateway gateway;
    private Object sealedProject;
    
    ProjectSupport(Gateway gateway, Object sealedProject) {
        this.gateway = gateway;
        this.sealedProject = sealedProject;
    }
    
    public AntSupport createAntSupport(String antName) {
        Object sealedAnt = gateway.instatiate("SealedAnt", antName, sealedProject);
        return new AntSupport(gateway, sealedAnt);
    }
    
    public void loadModuleClasses(String moduleName, String moduleVersion) {
        gateway.loadModuleClasses(moduleName, moduleVersion);
    }
    
    public void loadUrlClasses(String urlString) {
        try {
            URL url = new URL(urlString);
            gateway.loadUrlClasses(url);
        } catch (MalformedURLException e) {
            throw new RuntimeException("Cannot load URL " + urlString, e);
        }
    }
    
    public void fillAllPropertiesMap(ceylon.collection.HashMap<ceylon.language.String, ceylon.language.String> result) {
        @SuppressWarnings("unchecked")
        Map<String, String> properties = (Map<String, String>) gateway.invoke(sealedProject, "getAllProperties");
        for(String propertyName : properties.keySet()) {
            String propertyValue = properties.get(propertyName);
            ceylon.language.String propertyNameCeylonString = new ceylon.language.String(propertyName);
            ceylon.language.String propertyValueCeylonString = new ceylon.language.String(propertyValue);
            result.put(propertyNameCeylonString, propertyValueCeylonString);
        }
    }
    
    public String getProperty(String propertyName) {
        String property = (String) gateway.invoke(sealedProject, "getProperty", propertyName);
        return property;
    }
    
    public void setProperty(String propertyName, String propertyValue) {
        gateway.invoke(sealedProject, "setProperty", propertyName, propertyValue);
    }
    
    public String getBaseDirectory() {
        String baseDirectory = (String) gateway.invoke(sealedProject, "getBaseDirectory");
        return baseDirectory;
    }
    
    public void setBaseDirectory(String newBaseDirectory) {
        gateway.invoke(sealedProject, "setBaseDirectory", newBaseDirectory);
    }
    
    public void fillTopLevelAntDefinitionSupportList(ceylon.collection.LinkedList<AntDefinitionSupport> result) {
        @SuppressWarnings("unchecked")
        List<Object> sealedAntDefinitions = (List<Object>) gateway.invoke(sealedProject, "getTopLevelSealedAntDefinitions");
        for (Object sealedAntDefinition : sealedAntDefinitions) {
            AntDefinitionSupport antDefinitionSupport = new AntDefinitionSupport(gateway, sealedAntDefinition);
            result.add(antDefinitionSupport);
        }
    }
    
}
