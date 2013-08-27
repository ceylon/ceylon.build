"""This module defines the base elements of `ceylon.build` for declaring tasks.
   
   A simple `Task` can be created as below
   
   ```ceylon 
   Task hello = Task {
       name = "hello";
       process = function(Context context) {
           context.writer.info("Hello World!");
           return true;
       };
   };
   ```
   """
module ceylon.build.task '0.1' {}
