import ceylon.collection {
    ArrayList
}

"""
   Registers an `antlib` library with Ant for using types/tasks imported by [[AntProject.loadModuleClasses]] or [[AntProject.loadUrlClasses]].
   Internally just calls task `<typedef>` with a `resource` parameter.
"""
shared void registerAntLibrary(
    AntProject antProject,
    String location,
    Boolean? xmlFormat = null
) {
    ArrayList<String->String> attributes = ArrayList<String->String>();
    attributes.add("resource" -> location);
    attributes.add("onerror" -> "fail");
    if (exists xmlFormat) {
        attributes.add("format" -> (xmlFormat then "xml" else "properties"));
    }
    Ant ant = Ant("typedef", attributes);
    //print(ant.string);
    antProject.execute(ant);
}

"""
   Registers a `type` with Ant imported by [[AntProject.loadModuleClasses]] or [[AntProject.loadUrlClasses]].
   Wrapper for a `<typedef>` task.
"""
shared void registerAntType(
    AntProject antProject,
    String name,
    String className,
    String? adapterClassName = null,
    String? adaptToClassName = null
) {
    ArrayList<String->String> attributes = ArrayList<String->String>();
    attributes.add("name" -> name);
    attributes.add("classname" -> className);
    attributes.add("onerror" -> "fail");
    if (exists adapterClassName) {
        attributes.add("adapter" -> adapterClassName);
    }
    if (exists adaptToClassName) {
        attributes.add("adaptto" -> adaptToClassName);
    }
    Ant ant = Ant("typedef", attributes);
    //print(ant.string);
    antProject.execute(ant);
}

"""
   Registers a `task` with Ant imported by [[AntProject.loadModuleClasses]] or [[AntProject.loadUrlClasses]].
   Wrapper for a `<taskdef>` task.
"""
shared void registerAntTask(
    AntProject antProject,
    String name,
    String className,
    String? adapterClassName = null,
    String? adaptToClassName = null
) {
    ArrayList<String->String> attributes = ArrayList<String->String>();
    attributes.add("name" -> name);
    attributes.add("classname" -> className);
    attributes.add("onerror" -> "fail");
    if (exists adapterClassName) {
        attributes.add("adapter" -> adapterClassName);
    }
    if (exists adaptToClassName) {
        attributes.add("adaptto" -> adaptToClassName);
    }
    Ant ant = Ant("taskdef", attributes);
    //print(ant.string);
    antProject.execute(ant);
}

"""
   Executes an external XML based Ant file.
   Wrapper for an `<ant>` task.
"""
shared void executeExternalAntFile(
    "Current Ant project."
    AntProject antProject,
    "Name of the XML Ant file, defaults to `build.xml`."
    String? antFileName = null,
    "Base directory of new Ant project, unless [[useNativeBaseDirectory]] is set to true."
    String? baseDirectory = null,
    "Targets that should be called, seperated by space."
    String? targets = null,
    "File name to where output should be written."
    String? outputFile = null,
    "If `true` the new Ant project will recieve all properties of the current Ant instance."
    Boolean inheritProperties = true,
    "If `true` the new Ant project will recieve all references of the current Ant instance."
    Boolean inheritReferences = false,
    "If `true` the new Ant project will use the same base directory as it would have used when run from the command line."
    Boolean useNativeBaseDirectory = false,
    "Properties to set in the new Ant project."
    {<String->String>+}? properties = null,
    "References to inherit in the new Ant project. When using a tuple, the second tuple element is the new reference name."
    {<String|[String, String]>+}? references = null
) {
    ArrayList<String->String> attributes = ArrayList<String->String>();
    attributes.add("inheritAll" -> (inheritProperties then "true" else "false"));
    attributes.add("inheritRefs" -> (inheritReferences then "true" else "false"));
    attributes.add("useNativeBasedir" -> (useNativeBaseDirectory then "true" else "false"));
    if (exists antFileName) {
        attributes.add("antfile" -> antFileName);
    }
    if (exists baseDirectory) {
        attributes.add("dir" -> baseDirectory);
    }
    if (exists outputFile) {
        attributes.add("output" -> outputFile);
    }
    ArrayList<Ant> elements = ArrayList<Ant>();
    if (exists targets) {
        {String*} splittedTargets = targets.split(' '.equals, true, true);
        for (target in splittedTargets) {
            Ant targetElement = Ant("target", { "name"->target } );
            elements.add(targetElement);
        }
    }
    if (exists properties) {
        for (property in properties) {
            Ant propertyElement = Ant("property", { "name"->property.key, "value"->property.item } );
            elements.add(propertyElement);
        }
    }
    if (exists references) {
        for (reference in references) {
            String refid;
            String torefid;
            switch (reference)
            case (is String){
                refid = reference;
                torefid = reference;
            }
            case (is [String,String]){
                refid = reference[0];
                torefid = reference[1];
            }
            Ant referenceElement = Ant("property", { "refid"->refid, "torefid"->torefid } );
            elements.add(referenceElement);
        }
    }
    Ant ant = Ant("ant", attributes, elements.sequence());
    //print(ant.string);
    antProject.execute(ant);
}
