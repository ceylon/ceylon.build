import ceylon.build.tasks.ant { ant, activeAntProject, Ant, AntProject, AntDefinition, AntAttributeDefinition }
import ceylon.test { assertEquals, assertTrue, assertFalse, test }
import ceylon.file { File, Directory, Nil }

test void testEcho() {
    ant("echo", { "message" -> "G'day mate! " }, {}, "Cheerio!" );
}

test void testFileTasks() {
    String buildDirectory = "target/build-test-file-tasks-directory";
    Ant fileset = Ant("fileset", { "dir" -> "``buildDirectory``" }, [
        Ant("include", { "name" -> "example.txt" } )
    ] );
    ant("mkdir", { "dir" -> "``buildDirectory``" } );
    verifyResource("``buildDirectory``", `Directory`, "Cannot create directory");
    ant("echo", { "message" -> "File created.", "file" -> "``buildDirectory``/example.txt" } );
    verifyResource("``buildDirectory``/example.txt", `File`, "Cannot create file");
    ant("mkdir", { "dir" -> "``buildDirectory``/sub-directory" } );
    verifyResource("``buildDirectory``/sub-directory", `Directory`, "Cannot create directory");
    ant("copy", { "todir" -> "``buildDirectory``/sub-directory" }, [
        fileset
    ] );
    verifyResource("``buildDirectory``/sub-directory/example.txt", `File`, "Cannot copy to file");
    ant("delete", { }, [
        fileset
    ] );
    verifyResource("``buildDirectory``/example.txt", `Nil`, "Cannot delete file");
    ant("delete", { "dir" -> "``buildDirectory``", "verbose" -> "true" } );
    verifyResource("``buildDirectory``", `Nil`, "Cannot delete directory");
}

test void testAntDefinitions() {
    AntProject antProject = activeAntProject();
    List<AntDefinition> allTopLevelAntDefinitions = antProject.allTopLevelAntDefinitions();
    assertTrue(allTopLevelAntDefinitions.size > 0);
    printAntDefinitions();
}

test void testAntDefinition() {
    AntProject antProject = activeAntProject();
    AntDefinition? copyAntDefinition = filterAntDefinition(antProject.allTopLevelAntDefinitions(), "copy");
    assert(exists copyAntDefinition);
    {String*} copyAttributeNames = copyAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name);
    assertTrue(copyAttributeNames.contains("todir"));
    AntDefinition? filesetAntDefinition = filterAntDefinition(copyAntDefinition.nestedAntDefinitions(), "fileset");
    assert(exists filesetAntDefinition);
    {String*} filesetAttributeNames = filesetAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name);
    assertTrue(filesetAttributeNames.contains("dir"));
    AntDefinition? includeAntDefinition = filterAntDefinition(filesetAntDefinition.nestedAntDefinitions(), "include");
    assert(exists includeAntDefinition);
    {String*} includeAttributeNames = includeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name);
    assertTrue(includeAttributeNames.contains("name"));
}

test void testProperties() {
    AntProject antProject = activeAntProject();
    Map<String,String> allProperties = antProject.allProperties();
    assertTrue(allProperties.size > 0);
    // now print out all properties
    Collection<String> propertyNames = allProperties.keys;
    String[] propertyNamesSorted = propertyNames.sort(byIncreasing((String s) => s));
    for(propertyName in propertyNamesSorted) {
        String? propertyValue = allProperties.get(propertyName);
        if(exists propertyValue) {
            print("``propertyName``=``propertyValue``");
        }
    }
}

test void testProperty() {
    String propertyName = "test.ceylon.build.tasks.ant.test-property";
    String propertyConstant = "test-property-set";
    AntProject antProject = activeAntProject();
    antProject.setProperty(propertyName, null);
    String? propertyValue1 = antProject.getProperty(propertyName);
    assertEquals(propertyValue1, null);
    antProject.setProperty(propertyName, propertyConstant);
    String? propertyValue2 = antProject.getProperty(propertyName);
    assertEquals(propertyValue2, propertyConstant);
}

"""
   Checks the difference between top level <include> task and <include> datatype within <fileset>
"""
test void testIncludeAsTaskAndType() {
    AntProject antProject = activeAntProject();
    AntDefinition? includeAntDefinition = filterAntDefinition(antProject.allTopLevelAntDefinitions(), "include");
    assert(exists includeAntDefinition);
    print("<include: ``includeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name)``>");
    AntDefinition? copyAntDefinition = filterAntDefinition(antProject.allTopLevelAntDefinitions(), "copy");
    assert(exists copyAntDefinition);
    print("<copy: ``copyAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name)``>");
    AntDefinition? copyFilesetAntDefinition = filterAntDefinition(copyAntDefinition.nestedAntDefinitions(), "fileset");
    assert(exists copyFilesetAntDefinition);
    print("<copy-fileset: ``copyFilesetAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name)``>");
    AntDefinition? copyFilesetIncludeAntDefinition = filterAntDefinition(copyFilesetAntDefinition.nestedAntDefinitions(), "include");
    assert(exists copyFilesetIncludeAntDefinition);
    print("<copy-fileset-include: ``copyFilesetIncludeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name)``>");
    assertTrue(includeAntDefinition.isTask());
    assertTrue(includeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name).contains("taskname"));
    assertFalse(includeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name).contains("name"));
    assertFalse(copyFilesetIncludeAntDefinition.isTask());
    assertTrue(copyFilesetIncludeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name).contains("name"));
    assertFalse(copyFilesetIncludeAntDefinition.attributes().map<String>((AntAttributeDefinition a) => a.name).contains("taskname"));
}

"""
   Test whether a task with wrapped implementation can be executed.
"""
test void testImplementationWrapped() {
    AntProject antProject = activeAntProject();
    AntDefinition? waitforAntDefinition = filterAntDefinition(antProject.allTopLevelAntDefinitions(), "waitfor");
    assert(exists waitforAntDefinition);
    assertTrue(waitforAntDefinition.implementationWrapped, "Task waitfor should be implementationWrapped in Ant 1.9.4");
    antProject.setProperty("testImplementationWrapped", null);
    ant("waitfor", { "maxwait" -> "100", "checkevery" -> "10", "timeoutproperty" -> "testImplementationWrapped" } , [
        Ant("equals", { "arg1" -> "A", "arg2" -> "B" })
    ] );
    String? timeoutproperty = antProject.getProperty("testImplementationWrapped");
    "Check timeoutproperty"
    assert(exists timeoutproperty);
    assertTrue(timeoutproperty == "true");
}

"""
   Test whether the use of antlib of an external module works.
"""
test void testExternalTask() {
    AntProject antProject = activeAntProject();
    List<AntDefinition> allTopLevelAntDefinitions1 = antProject.allTopLevelAntDefinitions();
    antProject.addModule("ant-contrib.ant-contrib", "1.0b3");
    ant("taskdef", { "resource" -> "net/sf/antcontrib/antlib.xml", "onerror" -> "fail" } );
    List<AntDefinition> allTopLevelAntDefinitions2 = antProject.allTopLevelAntDefinitions();
    printAdditionalAntDefinitions(allTopLevelAntDefinitions1, allTopLevelAntDefinitions2);
    assertTrue(allTopLevelAntDefinitions1.size < allTopLevelAntDefinitions2.size);
    antProject.setProperty("testExternalTask", "one");
    ant("var", { "name" -> "testExternalTask", "value" -> "two" } );
    String? var = antProject.getProperty("testExternalTask");
    assert(exists var);
    assertTrue(var == "two");
}
