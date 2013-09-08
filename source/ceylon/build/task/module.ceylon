"""This module defines the base elements of `ceylon.build` for declaring tasks.
   
   A simple `Goal` can be created as below
   
   ```ceylon 
   Goal hello = Goal {
       name = "hello";
       task = function(Context context) {
           context.writer.info("Hello World!");
           return true;
       };
   };
   ```
   """
module ceylon.build.task '0.1' {}
