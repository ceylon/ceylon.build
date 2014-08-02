import ceylon.build.tasks.ant.internal {
    Gateway
}
import java.lang {
    JString = String
}

"""
   Basically it's a mapping from Ant's XML description language to Ceylon.
   Elements and attributes are `String`s as Ant itself has a dynamic nature.
   
   Consider the following Ant snippet:
   
   ```
   <property name="buildDirectory" value="target/build"/>
   <copy todir="${buildDirectory}/sub-directory">
       <fileset dir="${buildDirectory}">
           <include name="example.txt"/>
       </fileset>
   </copy>
   ```
   
   The above Ant snippet becomes with the value `buildDirectory` the following Ceylon code:
   
   ```
   value buildDirectory = "target/build";
   Ant("copy", { "todir" -> "``buildDirectory``/sub-directory" }, [
       Ant("fileset", { "dir" -> "``buildDirectory``" }, [
           Ant("include", { "name" -> "example.txt" } )
       ] )
   ] ).execute();
   ```
   
   Take care to include the last [[execute]] directive, otherwise the operation will not get executed, or use the function [[antExecute]] instead for Ant-tasks.
"""
see(`function antExecute`)
shared class Ant(
    "Name of Ant type (element name)."
    shared String antName,
    "Attributes for this type/task."
    {<String->String>*}? attributes = null,
    "Containing Ant elements."
    {<Ant>*}? elements = null,
    "Text node."
    String? text = null
) {
    
    void build(Gateway gateway, Object sealedAnt) {
        if(exists attributes) {
            for (attributeName -> attributeValue in attributes) {
                gateway.invoke(sealedAnt, "attribute", JString(attributeName), JString(attributeValue));
            }
        }
        if(exists elements) {
            for (element in elements) {
                Object nestedSealedAnt = gateway.invoke(sealedAnt, "createNestedElement", JString(element.antName));
                element.build(gateway, nestedSealedAnt);
                gateway.invoke(sealedAnt, "element", nestedSealedAnt);
            }
        }
        if(exists text) {
            gateway.invoke(sealedAnt, "setText", JString(text));
        }
    }
    
    """
       Executes the built up Ant directives.
    """
    shared void execute() {
        AntProjectImplementation antProjectImplementation = provideAntProjectImplementation();
        Gateway gateway = antProjectImplementation.gateway;
        Object sealedProject = antProjectImplementation.sealedProject;
        Object sealedAnt = gateway.instatiate("SealedAnt", JString(antName), sealedProject);
        build(gateway, sealedAnt);
        gateway.invoke(sealedAnt, "execute");
    }
    
    //"""
    //   Returns a readable string of the Ant representation as XML plus effective base directory.
    //"""
    //shared actual String string {
    //    String string =
    //            "
    //             Directory: ``antProjectImplementation.effectiveBaseDirectory()``
    //             Ant's XML: ``antSupport.string``
    //            ";
    //    return string;
    //}
    
}
