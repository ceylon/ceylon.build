import ceylon.build.tasks.ant.internal {
    AntSupport
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
    
    void build(AntSupport antSupport) {
        if(exists attributes) {
            for (attributeName -> attributeValue in attributes) {
                antSupport.attribute(attributeName, attributeValue);
            }
        }
        if(exists elements) {
            for (element in elements) {
                AntSupport elementAntHelper = antSupport.createNestedElement(element.antName);
                element.build(elementAntHelper);
                antSupport.element(elementAntHelper);
            }
        }
        if(exists text) {
            antSupport.setText(text);
        }
    }
    
    AntSupport buildAntSupport(AntProjectImplementation antProjectImplementation) {
        AntSupport antSupport = antProjectImplementation.projectSupport.createAntSupport(antName);
        build(antSupport);
        return antSupport;
    }
    
    """
       Executes the built up Ant directives.
    """
    shared void execute() {
        AntProjectImplementation antProjectImplementation = provideAntProjectImplementation();
        AntSupport antSupport = buildAntSupport(antProjectImplementation);
        antSupport.execute();
    }
    """
       Returns a readable string of the Ant representation as XML plus effective base directory.
    """
    shared actual String string {
        AntProjectImplementation antProjectImplementation = provideAntProjectImplementation();
        AntSupport antSupport = buildAntSupport(antProjectImplementation);
        String string =
                "
                 Directory: ``antProjectImplementation.effectiveBaseDirectory()``
                 Ant's XML: ``antSupport.string``
                ";
        return string;
    }
    
}
