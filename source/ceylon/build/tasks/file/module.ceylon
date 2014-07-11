"""Functions and `Task` wrappers to copy / delete files and directories.
   
   ### Delete
   
   This module provides two functions to delete files and directories.
   - [[delete]]: function to delete files / directories that can be used in your own tasks
   - [[delete]]: function creating a wrapper `Task` for [[delete]] function
   
   Here is an example of a task which will delete `"modules"` directory.
   ```ceylon
   Task cleanTarget = delete {
       path = parsePath("modules");
   };
   ```
   
   A filter can be added to that task to only delete files with extensions `"car"` and `"car.sha1"`
   ```ceylon
   Task cleanTarget = delete {
       path = parsePath("modules");
       filter = extensions("car", "car.sha1");
   };
   ```
   
   ### Copy
   
   This module provides two functions to copy files and directories.
   - [[copyFiles]]: function to copy files / directories that can be used in your own tasks
   - [[copy]]: function creating a wrapper `Task` for [[copyFiles]] function
   
   Here is an example of a task which will copy file `"modules/mymodule/1.0.0/module-1.0.0.car"`
   to `"container/modules"`.
   ```ceylon
   Task deploy = copy {
       source = parsePath("modules/mymodule/1.0.0/module-1.0.0.car");
       destination = parsePath("container/modules");
   };
   ```
   Note that copy acts the same way as the `cp` Unix command when a single file is given in input
   - If the destination is a directory, it will copy the file under the destination directory.
   (`modules/mymodule/1.0.0/module-1.0.0.car` -> `"container/modules/module-1.0.0.car` in our example)
   - If the destination is a file it will overwrite it or fail depending of overwrite configuration
   (`modules/mymodule/1.0.0/module-1.0.0.car` -> `"container/modules"` in our example)
   - If the destination doesn't exist, it will use copy input file to destination
   (`modules/mymodule/1.0.0/module-1.0.0.car` -> `"container/modules"` in our example)
   
   A directory can also be copied recursively as below
   ```ceylon
   Task deploy = copy {
       source = parsePath("modules");
       destination = parsePath("container/modules");
       filter = extensions("car");
   };
   ```
   """
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.tasks.file "1.1.0" {
    shared import ceylon.build.task "1.1.0";
    shared import ceylon.file "1.1.0";
}
