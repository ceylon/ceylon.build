import ceylon.build.tasks.ant {
    Ant,
    AntProject,
    AntDefinition,
    AntAttributeDefinition,
    registerAntLibrary,
    AntBuildException,
    AntBackendException,
    AntUsageException
}
import ceylon.file {
    File,
    Directory,
    Nil
}
import ceylon.test {
    assertEquals,
    assertTrue,
    assertFalse,
    test
}

test void testEcho() {
    AntProject antProject = createAntProjectWithBaseDirectorySet();
    antProject.execute(
        Ant("echo", { "message" -> "G'day mate! " }, {}, "Cheerio!" )
    );
}

test void testFileTasks() {
    AntProject antProject = createAntProjectWithBaseDirectorySet();
    String effectiveBaseDirectory = antProject.effectiveBaseDirectory();
    String buildDirectory = "target/build-test-file-tasks-directory";
    Ant fileset = Ant("fileset", { "dir" -> "``buildDirectory``" }, [
        Ant("include", { "name" -> "example.txt" } )
    ] );
    antProject.execute(
        Ant("mkdir", { "dir" -> "``buildDirectory``" } )
    );
    verifyResource(effectiveBaseDirectory, "``buildDirectory``", `Directory`, "Cannot create directory");
    antProject.execute(
        Ant("echo", { "message" -> "File created.", "file" -> "``buildDirectory``/example.txt" } )
    );
    verifyResource(effectiveBaseDirectory, "``buildDirectory``/example.txt", `File`, "Cannot create file");
    antProject.execute(
        Ant("mkdir", { "dir" -> "``buildDirectory``/sub-directory" } )
    );
    verifyResource(effectiveBaseDirectory, "``buildDirectory``/sub-directory", `Directory`, "Cannot create directory");
    antProject.execute(
        Ant("copy", { "todir" -> "``buildDirectory``/sub-directory" }, [
            fileset
        ] )
    );
    verifyResource(effectiveBaseDirectory, "``buildDirectory``/sub-directory/example.txt", `File`, "Cannot copy to file");
    antProject.execute(
        Ant("delete", { }, [
            fileset
        ] )
    );
    verifyResource(effectiveBaseDirectory, "``buildDirectory``/example.txt", `Nil`, "Cannot delete file");
    antProject.execute(
        Ant("delete", { "dir" -> "``buildDirectory``", "verbose" -> "true" } )
    );
    verifyResource(effectiveBaseDirectory, "``buildDirectory``", `Nil`, "Cannot delete directory");
}

test void testAntException() {
    AntProject antProject = createAntProjectWithBaseDirectorySet();
    try {
        antProject.execute(
            Ant("--error--", { } )
        );
        throw Exception("AntUsageException was expected.");
    } catch (AntUsageException e) {
        // Okay, expected
        //print(e);
    }
    try {
        antProject.execute(
            Ant("echo", { "--error--"->"" } )
        );
        throw Exception("AntUsageException was expected.");
    } catch (AntUsageException e) {
        // Okay, expected
        //print(e);
    }
    try {
        antProject.execute(
            Ant("copy", { }, [
                Ant("copy")
            ] )
        );
        throw Exception("AntUsageException was expected.");
    } catch (AntUsageException e) {
        // Okay, expected
        //print(e);
    }
    try {
        antProject.execute(
            Ant("mkdir", { } )
        );
        throw Exception("AntBuildException was expected.");
    } catch (AntBuildException e) {
         // Okay, expected
         //print(e);
    }
}

test void testAntDefinitions() {
    AntProject antProject = createAntProjectWithBaseDirectorySet();
    List<AntDefinition> allTopLevelAntDefinitions = antProject.allTopLevelAntDefinitions();
    assertTrue(allTopLevelAntDefinitions.size > 0);
    printAntDefinitions(allTopLevelAntDefinitions);
}

test void testAntDefinition() {
    AntProject antProject = createAntProjectWithBaseDirectorySet();
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
    AntProject antProject = createAntProjectWithBaseDirectorySet();
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
    AntProject antProject = createAntProjectWithBaseDirectorySet();
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
    AntProject antProject = createAntProjectWithBaseDirectorySet();
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
    AntProject antProject = createAntProjectWithBaseDirectorySet();
    AntDefinition? waitforAntDefinition = filterAntDefinition(antProject.allTopLevelAntDefinitions(), "waitfor");
    assert(exists waitforAntDefinition);
    assertTrue(waitforAntDefinition.implementationWrapped, "Task waitfor should be implementationWrapped in Ant 1.9.4");
    antProject.setProperty("testImplementationWrapped", null);
    antProject.execute(
        Ant("waitfor", { "maxwait" -> "100", "checkevery" -> "10", "timeoutproperty" -> "testImplementationWrapped" } , [
            Ant("equals", { "arg1" -> "A", "arg2" -> "B" })
        ] )
    );
    String? timeoutproperty = antProject.getProperty("testImplementationWrapped");
    "Check timeoutproperty"
    assert(exists timeoutproperty);
    assertTrue(timeoutproperty == "true");
}

"""
   Test whether the use of antlib of an external module works.
"""
test void testRegisterAntLibrary() {
    AntProject antProject = createAntProjectWithBaseDirectorySet();
    List<AntDefinition> allTopLevelAntDefinitions1 = antProject.allTopLevelAntDefinitions();
    antProject.loadModuleClasses("ant-contrib.ant-contrib", "1.0b3");
    registerAntLibrary(antProject, "net/sf/antcontrib/antlib.xml");
    List<AntDefinition> allTopLevelAntDefinitions2 = antProject.allTopLevelAntDefinitions();
    printAdditionalAntDefinitions(allTopLevelAntDefinitions1, allTopLevelAntDefinitions2);
    assertTrue(allTopLevelAntDefinitions1.size < allTopLevelAntDefinitions2.size);
    antProject.setProperty("testRegisterAntLibrary", "one");
    antProject.execute(
        Ant("var", { "name" -> "testRegisterAntLibrary", "value" -> "two" } )
    );
    String? var = antProject.getProperty("testRegisterAntLibrary");
    assert(exists var);
    assertTrue(var == "two");
}
