import ceylon.build.task { Goal, GoalGroup }
import ceylon.collection { HashMap }
import java.util.regex { Pattern { compilePattern = compile } }
import ceylon.interop.java { javaString }

shared {<Goal|GoalGroup>*} invalidGoalsName({<Goal|GoalGroup>+} goals) {
    return goals.select((Goal|GoalGroup goal) => invalidGoalName(goal.name));
}

String validTaskNamePattern = "[a-z][a-zA-Z0-9-.]*";

Pattern validTaskName = compilePattern(validTaskNamePattern);

shared Boolean invalidGoalName(String name) {
    return !validTaskName.matcher(javaString(name.string)).matches();
}

shared {String*} findDuplicateGoals({<Goal|GoalGroup>+} goals) {
    value map = HashMap<String, Integer>();
    for (goal in goals) {
        String name = goal.name;
        Integer count = map.get(name) else 0;
        map.put(name, count + 1);
    }
    return [ for (name -> count in map) if (count > 1) name ];
}