import ceylon.build.task { Goal }
import ceylon.collection { HashMap }
import java.util.regex { Pattern { compilePattern = compile } }
import ceylon.interop.java { javaString }

{Goal*} invalidGoalsName({Goal+} goals) {
    return goals.select((Goal goal) => invalidGoalName(goal.name));
}

String validTaskNamePattern = "[a-z][a-zA-Z0-9-.]*";

Pattern validTaskName = compilePattern(validTaskNamePattern);

Boolean invalidGoalName(String name) {
    return !validTaskName.matcher(javaString(name.string)).matches();
}

{String*} findDuplicateGoals({Goal+} goals) {
    value map = HashMap<String, Integer>();
    for (goal in goals) {
        String name = goal.name;
        Integer count = map.get(name) else 0;
        map.put(name, count + 1);
    }
    return [ for (name -> count in map) if (count > 1) name ];
}