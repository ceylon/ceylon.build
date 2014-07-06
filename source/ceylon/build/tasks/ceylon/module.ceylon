"""Provides `Task` to launch ceylon `compile`, `compile-js`, `doc`, `run`, `run-js` command line tools
   
   ### Compile
   Tasks to compile to both jvm and javascript backend are available.
   They support various options.
   
   A simple task to compile to jvm backend:
   ```ceylon
   Task compileTask = compile {
       modules = "my.module";
   };
   ```
   A simple task to compile to javascript backend:
   ```ceylon
   Task compileJsTask = compileJs {
       modules = "my.module";
   };
   ```
   Several modules can be compile at once:
   ```ceylon
   Task compileTask = compile {
       modules = ["my.module1", "my.module2"];
   };
   ```
   Compiler options can be configured:
   ```ceylon
   Task compileTask = compile {
       modules = ["my.module", "test.my.module"];
       encoding = "UTF-8";
       sourceDirectories = ["source", "test-source"];
       outputRepository = "~/.ceylon/repo";
   };
   ```
   #### Compile tests
   Tasks to compile tests are provided.
   They are shortcuts for respectively [[ceylon.compile]] and [[ceylon.compileJs]] functions with
   `sourceDirectories` argument set to `["test-source"]`
    
   Task to compile tests to jvm backend:
   ```ceylon
   Task compileTestsTask = compileTests {
       modules = "test.my.module";
   };
   ```
   Task to compile tests to javascript backend:
   ```ceylon
   Task compileJsTestsTask = compileJsTests {
       modules = "test.my.module";
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
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.tasks.ceylon "1.1.0" {
    shared import ceylon.build.task "1.1.0";
    shared import ceylon.file "1.1.0";
    
    import ceylon.build.tasks.commandline "1.1.0";
    import ceylon.build.tasks.file "1.1.0";
    import ceylon.collection "1.1.0";
    import com.redhat.ceylon.compiler.java "1.1.0";
    import org.jboss.modules "1.3.3.Final";

    import java.base "7";
    import ceylon.interop.java "1.1.0";
}
