import ceylon.collection { MutableList, ArrayList }

"Name of ceylon executable"
shared String ceylonExecutable = operatingSystem.name.lowercased.startsWith("windows") then "ceylon.bat" else "ceylon";

"Default module version (1.0.0)"
shared String? defaultModuleVersion = null;

"Build a module name/version string from a name and a version"
shared String moduleVersion(String name, String? version = defaultModuleVersion) {
    if (exists version) {
        return "``name``/``version``";
    }
    return name;
}

[String+] testSourceDirectory = ["test-source"];
[String+] testResourceDirectory = ["test-resource"];

void checkCompilationUnits({String*} modules, {String*} files) {
    value compilationUnits = concatenate(modules, files).sequence();
    "Modules and/or files to compile must be provided"
    assert (nonempty compilationUnits);
}

{String+} multipleStringsIterable(String|{String+} stringOrMultipleStrings) {
    {String+} stringIterable;
    switch(stringOrMultipleStrings)
    case (is String) {
        stringIterable = {stringOrMultipleStrings};
    }
    case (is {String+}) {
        stringIterable = stringOrMultipleStrings;
    }
    return stringIterable;
}

{String*} stringIterable(String|{String*} stringOrStrings) {
    {String*} stringIterable;
    switch(stringOrStrings)
    case (is String) {
        stringIterable = {stringOrStrings};
    }
    case (is {String*}) {
        stringIterable = stringOrStrings;
    }
    return stringIterable;
}

"Initializes a command Iterable whose first element is the tool name."
MutableList<String?> initCommand(String tool) => ArrayList<String?> { initialCapacity = 2; tool };

"Removes null elements from command and convert it to a non-empty sequence."
[String+] cleanCommand({String?*} command) {
    value sequence = command.coalesced.sequence();
    assert(nonempty sequence);
    return sequence;
}
