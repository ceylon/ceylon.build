"""Provides `Task` to launch ceylon `compile`, `compile-js`, `doc`, `run`, `run-js` command line tools
   
   ### Compile
   Tasks to compile to both jvm and javascript backend are available.
   They support various options.
   
   A simple task to compile to jvm backend:
   ```ceylon
   Task compileTask = compile {
       compilationUnits = "my.module";
   };
   ```
   A simple task to compile to javascript backend:
   ```ceylon
   Task compileJsTask = compileJs {
       compilationUnits = "my.module";
   };
   ```
   Several modules can be compile at once:
   ```ceylon
   Task compileTask = compile {
       compilationUnits = ["my.module1", "my.module2"];
   };
   ```
   Compiler options can be configured:
   ```ceylon
   Task compileTask = compile {
       compilationUnits = ["my.module", "test.my.module"];
       encoding = "UTF-8";
       sourceDirectories = ["source", "test-source"];
       outputModuleRepository = "~/.ceylon/repo";
   };
   ```
   #### Compile tests
   Tasks to compile tests are provided.
   They are shortcuts for respectively [[compile]] and [[compileJs]] functions with
   `sourceDirectories` argument set to `["test-source"]`
    
   Task to compile tests to jvm backend:
   ```ceylon
   Task compileTestsTask = compileTests {
       compilationUnits = "test.my.module";
   };
   ```
   Task to compile tests to javascript backend:
   ```ceylon
   Task compileJsTestsTask = compileJsTests {
       compilationUnits = "test.my.module";
   };
   ```
   
   ### Doc
   A simple document task:
   ```ceylon
   Task documentTask = document {
       modules = "my.module";
   };
   ```
   Several options can be configured:
   ```ceylon
   Task documentTask = document {
       modules = "my.module";
       includeSourceCode = true;
       includeNonShared = true;
   };
   ```
   
   ### Run
   A simple task to run a module on jvm backend:
   ```ceylon
   Task runTestsTask = runModule {
       moduleName = "test.my.module";
       version = "1.0.0";
   };
   ```
   
   A simple task to run a module on javascript backend:
   ```ceylon
   Task runJsTestsTask = runModule {
       moduleName = "test.my.module";
       version = "1.0.0";
   };
   ```
   
   Several options can be configured:
   ```ceylon
   Task runTestsTask = runModule {
       moduleName = "test.my.module";
       version = "1.0.0";
       functionNameToRun = "customMain";
   };
   ```
   """
license("http://www.apache.org/licenses/LICENSE-2.0")
module ceylon.build.tasks.ceylon "0.1" {
    shared import ceylon.build.task "0.1";
    import ceylon.build.tasks.commandline "0.1";
}
