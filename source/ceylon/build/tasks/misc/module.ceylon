"""All purpose tasks
   
   ### echo
   
   Echo text on the build console.

   ```ceylon
   Task cleanTarget = echo { "Hello World" };
   ```
   """
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.tasks.misc "1.1.1" {
    shared import ceylon.build.task "1.1.1";
    shared import ceylon.file "1.1.1";
}
