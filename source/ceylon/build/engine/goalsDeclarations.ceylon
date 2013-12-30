import java.util.regex { Pattern { compilePattern = compile } }
import ceylon.interop.java { javaString }

[String*] invalidGoalsName({String*} names) {
    return names.select((String name) => invalidGoalName(name));
}

String validTaskNamePattern = "[a-z][a-zA-Z0-9-.]*";

Pattern validTaskName = compilePattern(validTaskNamePattern);

Boolean invalidGoalName(String name) {
    return !validTaskName.matcher(javaString(name.string)).matches();
}

[String*] duplicatedDefinitions(Map<String, {GoalProperties+}> definitions)
        => [ for (entry in definitions) if (entry.item.size > 1) entry.key ];
