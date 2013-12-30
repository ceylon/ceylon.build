
shared final class DefinitionsValidationResult(original, invalidNames, duplicated, dependencyCycles) {
    
    "Original information about goals definitions.
     May contains definitions with duplicate or invalid names."
    shared Map<String, {GoalProperties+}> original;
    
    "List of definitions with invalid names"
    shared [String*] invalidNames;
    
    "`true` if contains definitions with invalid names"
    shared Boolean hasInvalidNames= !invalidNames.empty;
    
    "List of duplicate definitions"
    shared [String*] duplicated;
    
    "`true` if contains duplicate definitions"
    shared Boolean hasDuplicatedDefinitions = !duplicated.empty;
    
    "List of duplicated definitions"
    shared {<String->{String*}>*} dependencyCycles;
    
    "`true` if contains duplicate definitions"
    shared Boolean hasDependencyCycles = !dependencyCycles.empty;
    
    "`true` if all definitions are valid"
    shared Boolean valid = !hasDuplicatedDefinitions && !hasInvalidNames && !hasDependencyCycles;
    
    "Goals definitions to use for processing or null if `valid` is `false`"
    shared GoalDefinitions? definitions;
    
    if (valid) {
        definitions = GoalDefinitions({ for (entry in original) entry.key->entry.item.first });
    } else {
        definitions = null;
    }
    
    string => "original definitions: ``original``
               definitions: ``definitions else "<null>"``
               hasInvalidNames: ``hasInvalidNames then "true ``invalidNames``" else "false"``
               hasDuplicatedDefinitions: ``hasDuplicatedDefinitions then "true ``duplicated``" else "false"``";
}
