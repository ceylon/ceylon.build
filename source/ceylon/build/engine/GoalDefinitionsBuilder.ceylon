import ceylon.collection { HashMap }

shared final class GoalDefinitionsBuilder({Goal*} goals = []) {
    
    value definitions = SequenceBuilder<Goal>();
    definitions.appendAll(goals);
    
    shared void add(Goal definition) {
        definitions.append(definition);
    }
    
    shared DefinitionsValidationResult validate() {
        value original = definitionsMap();
        value invalidNames = invalidGoalsName(original.map((String->{GoalProperties+} entry) => entry.key));
        value duplicated = duplicatedDefinitions(original);
        value cycles = !duplicated.empty then analyzeDependencyCycles(toDependencyGraph(original)) else [];
        return DefinitionsValidationResult(original, invalidNames, duplicated, cycles);
    }
    
    Map<String, {GoalProperties+}> definitionsMap() {
        value definitionsMap = HashMap<String, SequenceAppender<GoalProperties>>();
        for (definition in definitions.sequence) {
            value name = definition.name;
            if (exists seqBuilder = definitionsMap.get(name)) {
                seqBuilder.append(definition.properties);
            } else {
                value seqBuilder = SequenceAppender<GoalProperties>([definition.properties]);
                definitionsMap.put(name, seqBuilder);
            }
        }
        return HashMap {
            entries = { for (entry in definitionsMap) entry.key->entry.item.sequence };
        };
    }
    
    "Transforms a `Map<String,{GoalProperties+}>` into a `DependencyGraph`.
     
     Note that only the first `GoalProperties` will be taken into account
     as if there are multiples, there's already a duplicate goal problem."
    DependencyGraph toDependencyGraph(Map<String,{GoalProperties+}> original) {
        return { for (entry in original) entry.key-> dependencies(entry.item.first) };
    }
}
