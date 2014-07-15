import ceylon.build.tasks.ant.internal { AntSupport, AntProjectImplementation }

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
   
   Take care to include the last `.execute()` directive, otherwise the operation will not get executed, or use the function `ant()` instead for Ant-tasks.
"""
see(`function ant`)
shared class Ant(
        antName,
        {<String->String>*}? attributes = null,
        {<Ant>*}? elements = null,
        String? text = null) {
    
    """
       Name of ant type (element name).
    """
    shared String antName;
    
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
        AntSupport antSupport = AntSupport(antName, antProjectImplementation.projectSupport);
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
    
    shared actual String string {
        AntProjectImplementation antProjectImplementation = provideAntProjectImplementation();
        AntSupport antSupport = buildAntSupport(antProjectImplementation);
        String string = "
                         Directory: ``antProjectImplementation.effectiveBaseDirectory()``
                         Ant's XML: ``antSupport.string``
                         ";
        return string;
    }
    
}

"""
   Convenience method to build `execute()` an `Ant` class when it's an Ant-task.
   
   ```
   value buildDirectory = "target/build-test-file-tasks-directory";
   ant("copy", { "todir" -> "``buildDirectory``/sub-directory" }, [
       Ant("fileset", { "dir" -> "``buildDirectory``" }, [
           Ant("include", { "name" -> "example.txt" } )
       ] )
   ] );
   ```
"""
see(`class Ant`)
shared void ant(
        String antName,
        {<String->String>*}? attributes = null,
        {<Ant>*}? elements = null,
        String? text = null) {
    Ant(antName, attributes, elements, text).execute();
}
