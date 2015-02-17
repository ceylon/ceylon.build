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

class AntAttributeDefinitionImplementation(name, className) satisfies AntAttributeDefinition {
    shared actual String name;
    shared actual String className;
}
