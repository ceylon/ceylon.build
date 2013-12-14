
"""
   # Simple build module
   Here is a simple build module sample with one goal named `"hello"`
   which will just print the `"Hello World"` string.
   
   ## Code
   ```ceylon
   import ceylon.build.engine { build }
   import ceylon.build.task { Goal }
   import ceylon.build.tasks.misc { echo }
   
   void run() {
       build {
           project = "My Build Project";
           Goal {
               name = "hello";
               echo("Hello World")
           }
       };
   }
   ```
   
   ## Execution
   To start the console, run this module with `ceylon run build --console`
   
   ```text
   Available goals: [hello]
   Enter Ctrl + D to quit
   >
   ```
   If you enter `"hello"`, hello goal will be run.
   ```text
   ## ceylon.build:
   # running goals: [hello] in order
   # running hello()
   hello
   >
   ```
   If you want to run multiple goals or specify parameters for a goal as
   when launched from command line, you can by using the same syntax:
   `goal1 goal2 -Dgoal1:param=value`
   
   To quit, just enter the EOT character (Ctrl + D)
   """
shared package sample.ceylon.build.console;
