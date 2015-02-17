import ceylon.collection {
    HashMap,
    ArrayList
}
import ceylon.interop.java {
    javaString
}

import java.util.regex {
    Pattern {
        compilePattern=compile
    }
}

shared final class GoalDefinitionsBuilder({Goal*} goals = []) {
    
    String validTaskNamePattern = "[a-z][a-zA-Z0-9-.]*";
    
    Pattern validTaskName = compilePattern(validTaskNamePattern);
    
    value definitions = ArrayList<Goal>();
    definitions.addAll(goals);
    
    shared void add(Goal definition) {
        definitions.add(definition);
    }
    
    shared DefinitionsValidationResult validate() {
        value original = definitionsMap();
        value invalidNames = invalidGoalsName(original.map((String->{GoalProperties+} entry) => entry.key));
        value duplicated = duplicatedDefinitions(original);
        value undefined = undefinedGoals(original);
        value canCheckForDependencyCycles = undefined.empty && duplicated.empty;
        value cycles = canCheckForDependencyCycles then analyzeDependencyCycles(toDependencyGraph(original)) else [];
        return DefinitionsValidationResult(original, invalidNames, undefined, duplicated, cycles);
    }
    
    Map<String, {GoalProperties+}> definitionsMap() {
        value definitionsMap = HashMap<String, ArrayList<GoalProperties>>();
        for (definition in definitions.sequence()) {
            value name = definition.name;
            if (exists list = definitionsMap.get(name)) {
                list.add(definition.properties);
            } else {
                value list = ArrayList<GoalProperties>();
                list.add(definition.properties);
                definitionsMap.put(name, list);
            }
        }
        value result = HashMap<String, {GoalProperties+}>();
        for (entry in definitionsMap) {
            value sequence = entry.item.sequence();
            assert(nonempty sequence);
            result.put(entry.key, sequence);
        }
        return result;
    }
    
    Boolean invalidGoalName(String name) {
        return !validTaskName.matcher(javaString(name.string)).matches();
    }
    
    [String*] invalidGoalsName({String*} names) {
        return names.select((String name) => invalidGoalName(name));
    }
    
    [String*] duplicatedDefinitions(Map<String, {GoalProperties+}> definitions)
            => [ for (entry in definitions) if (entry.item.size > 1) entry.key ];
    
    [String*] undefinedGoals(Map<String,{GoalProperties+}> original) =>
            [ for (properties in original.items)
                for (property in properties)
                    for (dependency in property.dependencies)
                        if (!original.defines(dependency))
                            dependency ];
    
    "Transforms a `Map<String,{GoalProperties+}>` into a `DependencyGraph`.
     
     Note that only the first `GoalProperties` will be taken into account
     as if there are multiples, there's already a duplicate goal problem."
    DependencyGraph toDependencyGraph(Map<String,{GoalProperties+}> original) {
        return { for (entry in original) entry.key-> dependencies(entry.item.first) };
    }
}
