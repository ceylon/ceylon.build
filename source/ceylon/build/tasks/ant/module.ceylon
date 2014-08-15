"""
   # Apache Ant wrapper
   
   Enables you to write Apache Ant scripts in Ceylon.
   [Apache Ant](https://ant.apache.org/) is a build/batch tool widely used by Java programmers, with which XML is commonly used as definition language.
   
   It facilitates the use of Ant-types, Ant-tasks, and Ant-processes, including introspection, being used within Ceylon.
   It is not intended to imitate Ant's `target` mechanism.
   
   
   
   ## Usage
   
   Basically it's a mapping from Ant's XML description language to Ceylon.
   Elements and attributes are `String`s as Ant itself has a dynamic nature.
   
   Also it is important to distinguish between Ant types and Ant tasks.
   Types are data holders like `<fileset>` and task are executables like `<copy>`.
   
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
   
   So types like `<fileset>` are built using the [[Ant]] class.
   
   You can also execute XML directly, or convert an [[Ant]] object to `String`, and then use [[AntProject.executeXml]].
   You cannot define Ant targts with `executeXml()` as it only accepts types and tasks.
   
   ```
   Ant ant = Ant("echo", { "message" -> "Hi!" } );
   antProject.executeXml(ant.string);
   ```
   
   
   
   ## External modules
   
   Ant allows users to add their own types and tasks by adding them to Java's classpath.
   As the module system doesn't allow using classes from modules not imported directly, you need an extra step to load the required classes so Ant is able to use them.
   This is done by [[AntProject.loadModuleClasses]] for loading a module, or by [[AntProject.loadUrlClasses]] for loading a JAR.
   These operations then add the classes to the class loader of `ceylon.build.tasks.ant`.
   Before actually using any these types and tasks you have to initialize Ant with `<typedef>` or `<taskdef>`.
   
   Example:
   
   ```
   AntProject antProject = AntProject();
   antProject.loadModuleClasses("org.apache.ant.ant-commons-net", "1.9.4");
   Ant ant = Ant("taskdef", { "name" -> "ftp", "classname" -> "org.apache.tools.ant.taskdefs.optional.net.FTP" } );
   antProject.execute(ant);
   ```
   
   Instead of constructing a `<typedef>` or `<taskdef>` yourself, you can use the convenience functions [[registerAntLibrary]], [[registerAntType]], or [[registerAntTask]].
   
   
   
   ## Introspection
   
   Ant introspection works from top down, as the implementing classes of Ant types change depending on their location in the XML hierarchy.
   
   Example:
   
   ```
   AntProject antProject = AntProject();
   AntDefinition[] allProjectDefinitions = antProject.allTopLevelAntDefinitions();
   AntDefinition? copyAntDefinition = allProjectDefinitions.find((AntDefinition a) => a.antName == "copy");
   assert(exists copyAntDefinition);
   AntDefinition[] nestedCopyDefinitions = copyAntDefinition.nestedAntDefinitions();
   AntDefinition? filesetAntDefinition = nestedCopyDefinitions.find((AntDefinition a) => a.antName == "fileset");
   assert(exists filesetAntDefinition);
   AntDefinition[] nestedFilesetDefinitions = filesetAntDefinition.nestedAntDefinitions();
   AntDefinition? includeAntDefinition = nestedFilesetDefinitions.find((AntDefinition a) => a.antName == "include");
   assert(exists includeAntDefinition);
   ```
   
   
   
   ## Caveats
   
   XML/Ant namespaces are not supported.
   But you can use [[AntProject.executeXml]] if you really need them.
   
   Due to the implementation of Ant and its numerous external types/tasks you may encounter [[AntBackendException]]s that should be handled correctly.
   [[AntProject.executeXml]] might help here again.
"""
by ("Henning Burdack")
license ("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.tasks.ant "1.1.0"{
    shared import ceylon.collection "1.1.0";
    import java.base "7";
    import org.apache.ant.ant "1.9.4";
    import org.jboss.modules "1.3.3.Final"; // needed for manual modules loading
}
