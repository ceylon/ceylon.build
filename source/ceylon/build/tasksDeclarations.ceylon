import ceylon.collection { HashMap }
import java.util.regex { Pattern { compilePattern = compile } }
import ceylon.interop.java { javaString }

Pattern validTaskName = compilePattern("[a-z][a-zA-Z0-9-]*");

shared {Task*} invalidTasksName({Task+} tasks) {
    return tasks.select((Task task) => invalidTaskName(task.name));
}

shared Boolean invalidTaskName(String name) {
    return !validTaskName.matcher(javaString(name.string)).matches();
}

shared {String*} findDuplicateTasks({Task+} tasks) {
    value map = HashMap<String, Integer>();
    for (task in tasks) {
        String name = task.name;
        Integer count = map.get(name) else 0;
        map.put(name, count + 1);
    }
    return [ for (name -> count in map) if (count > 1) name ];
}