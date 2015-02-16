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
   // create AntProject, only needed once
   AntProject antProject = AntProject();
   // define arbitrary value
   String buildDirectory = "target/build";
   // define Ant structure
   Ant ant = Ant("copy", { "todir" -> "``buildDirectory``/sub-directory" }, [
       Ant("fileset", { "dir" -> "``buildDirectory``" }, [
           Ant("include", { "name" -> "example.txt" } )
       ] )
   ] );
   // execute
   antProject.execute(ant);
   ```
"""
shared class Ant(antName, attributes = null, elements = null, text = null) {
    
    """
       Name of Ant type (element name).
    """
    shared String antName;
    
    """
       Attributes for this type/task.
    """
    shared {<String->String>*}? attributes;
    
    """
       Containing Ant elements.
    """
    shared Ant[]? elements;
    
    """
       Text node.
    """
    shared String? text;
    
    """
       Returns a readable string of the Ant representation as XML.
       Doesn't do XML escaping.
    """
    shared actual String string {
        StringBuilder stringBuilder = StringBuilder();
        String newline = operatingSystem.newline;
        buildXmlRepresentation(stringBuilder, "", newline);
        stringBuilder.append(newline);
        return stringBuilder.string;
    }
    
    void buildXmlRepresentation(StringBuilder stringBuilder, String prefixSpaces, String newline) {
        stringBuilder.append(prefixSpaces).append("<").append(antName);
        if (exists attributes) {
            for (attribute in attributes) {
                stringBuilder.append(" ").append(attribute.key).append("=\"").append(attribute.item).append("\"");
            }
        }
        if (elements exists || text exists) {
            stringBuilder.append(">");
            if (nonempty elements) {
                stringBuilder.append(newline);
                for (element in elements) {
                    element.buildXmlRepresentation(stringBuilder, "``prefixSpaces``    ", newline);
                }
            }
            if (exists text) {
                stringBuilder.append(text);
            } else {
                stringBuilder.append(newline);
            }
            stringBuilder.append(prefixSpaces).append("</").append(antName).append(">");
        } else {
            stringBuilder.append("/>");
        }
    }
    
}
