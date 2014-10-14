import ceylon.collection {
    ArrayList,
    StringBuilder
}

import java.lang {
    JString=String
}
import java.util {
    JList=List
}

"""
   Represents Ant's Project class, with the ability to access properties, Ant type definitions, and executing Ant tasks.
"""
shared class AntProject() {
    
    Gateway gateway = Gateway();
    Object sealedProject = gateway.instatiate("SealedProject");
    
    """
       Gives all available Ant properties in this project.
    """
    shared {<String->String>*} allProperties() {
        Anything allProperties = gateway.invoke(sealedProject, "getAllProperties");
        return toStringMap(allProperties);
    }
    
    """
       Gives a specific Ant property.
    """
    shared String? getProperty(String propertyName) {
        Anything property = gateway.invoke(sealedProject, "getProperty", JString(propertyName));
        return toStringOrNull(property);
    }
    
    """
       Sets an Ant property.
    """
    shared void setProperty(String propertyName, String? propertyValue) {
        switch (propertyValue)
        case (is Null) {
            gateway.invoke(sealedProject, "unsetProperty", JString(propertyName));
        }
        case (is String) {
            gateway.invoke(sealedProject, "setProperty", JString(propertyName), JString(propertyValue));
        }
    }
    
    """
       Retrieves or sets a new base directory for the current Ant project.
    """
    shared String effectiveBaseDirectory(String? newBaseDirectory = null) {
        if(exists newBaseDirectory) {
            gateway.invoke(sealedProject, "setBaseDirectory", JString(newBaseDirectory));
        }
        Anything baseDirectory = gateway.invoke(sealedProject, "getBaseDirectory");
        return toString(baseDirectory);
    }
    
    void build(Gateway gateway, Ant ant, Object sealedAnt) {
        value attributes = ant.attributes;
        if(exists attributes) {
            for (attributeName -> attributeValue in attributes) {
                gateway.invoke(sealedAnt, "attribute", JString(attributeName), JString(attributeValue));
            }
        }
        value elements = ant.elements;
        if(exists elements) {
            for (element in elements) {
                Anything nestedSealedAnt = gateway.invoke(sealedAnt, "createNestedElement", JString(element.antName));
                "Could not create nested element."
                assert(exists nestedSealedAnt);
                build(gateway, element, nestedSealedAnt);
                gateway.invoke(sealedAnt, "storeNestedElement", nestedSealedAnt);
            }
        }
        value text = ant.text;
        if(exists text) {
            gateway.invoke(sealedAnt, "setText", JString(text));
        }
    }
    
    """
       Executes the built up Ant directives.
    """
    shared void execute(Ant* ants) {
        for (ant in ants) {
            Object sealedAnt = gateway.instatiate("SealedAnt", JString(ant.antName), sealedProject);
            build(gateway, ant, sealedAnt);
            //print(ant.string);
            gateway.invoke(sealedAnt, "execute");
        }
    }
    
    """
       Executes Ant XML. Only types and tasks are allowed, no targets.
    """
    shared void executeXml(<Ant|String>* antXmls) {
        StringBuilder stringBuilder = StringBuilder();
        for(antXml in antXmls) {
            String xml = antXml.string;
            stringBuilder.append(xml);
            if (!xml.endsWith("\n") && !xml.endsWith("\n\r")) {
                stringBuilder.append(operatingSystem.newline);
            }
        }
        String string = stringBuilder.string;
        //print(string);
        gateway.invoke(sealedProject, "executeXml", JString(string));
    }
    
    """
       Root of Ant type introspection.
       Gives all top level Ant defintions.
       Ant introspection works from top down, as the implementing classes of Ant types change depending on their location in the XML hierarchy.
    """
    shared AntDefinition[] allTopLevelAntDefinitions() {
        Anything sealedAntDefinitions = gateway.invoke(sealedProject, "getTopLevelSealedAntDefinitions");
        "Java List expected."
        assert(is JList<out Anything> sealedAntDefinitions);
        ArrayList<AntDefinition> allTopLevelAntDefinitions = ArrayList<AntDefinition>();
        value jIterator = sealedAntDefinitions.iterator();
        while (jIterator.hasNext()){
            Anything sealedAntDefinition = jIterator.next();
            assert(is Object sealedAntDefinition);
            AntDefinition topLevelAntDefinition = AntDefinitionImplementation(gateway, sealedAntDefinition);
            allTopLevelAntDefinitions.add(topLevelAntDefinition);
        }
        return allTopLevelAntDefinitions.sequence();
    }
    
    """
       Loads classes from a given module so that they are accessible from Ant.
       Before using loaded classes as types/tasks, you have to register them with Ant.
       For registering either use `<typedef>`/`<taskdef>` or any of [[registerAntLibrary]], [[registerAntType]], [[registerAntTask]].
    """
    shared void loadModuleClasses(String moduleName, String moduleVersion) {
        gateway.loadModuleClasses(moduleName, moduleVersion);
    }
    
    """
       Loads classes from a given URL so that they are accessible from Ant.
       Before using loaded classes as types/tasks, you have to register them with Ant.
       For registering either use `<typedef>`/`<taskdef>` or any of [[registerAntLibrary]], [[registerAntType]], [[registerAntTask]].
    """
    shared void loadUrlClasses(String url) {
        gateway.loadUrlClasses(url);
    }
    
}
