"""
   # Simple build module
   Here is a simple build module sample with two goals
   - `"compile"` which will compile the module named `"mymodule"`
   - `"doc"` which will document this same module.
   
   ## Code
   ```ceylon
   import ceylon.build.engine { build }
   import ceylon.build.task { Goal }
   import ceylon.build.tasks.ceylon { compile, document }
   
   void run() {
       build {
           project = "My Build Project";
           Goal {
               name = "compile";
               compile {
                   modules = "mymodule";
               }
           },
           Goal {
               name = "doc";
               document {
                   modules = "mymodule";
               }
           }
       };
   }
   ```
   ## Execution
   ### Run without goals
   Execution of `ceylon run mybuildmodule/x.y` will exit in error because no goal
   has been provided to the engine.
   
   ```text
   ## ceylon.build: My Build Project
   # no goal to run, available goals are: [compile, doc]
   ## failure - duration 0s
   ```
   
   ### Run with one goal
   Execution of `ceylon run mybuildmodule/x.y compile` will execute `"compile"` goal.
   
   ```text
   ## ceylon.build: My Build Project
   # running goals: [compile] in order
   # running compile()
   compiling: 'ceylon compile mymodule'
   Note: Created module mymodule/x.y
   ## success - duration 1s
   ```
   
   ### Run with multiple goals
   Several goals can be launch sequentially
   
   Execution of `ceylon run mybuildmodule/x.y compile doc` will execute `"compile"` and then `"doc"` goals.
   
   ```text
   ## ceylon.build: My Build Project
   # running goals: [compile, doc] in order
   # running compile()
   compiling: 'ceylon compile mymodule'
   Note: Created module mymodule/x.y
   # running doc()
   documenting: 'ceylon doc mymodule'
   ## success - duration 1s
   ```
   
   In a general manner, the order of execution of goals is the one provided in the command line unless it doesn't
   satisfy dependencies.
   
   ### Arguments
   Some tasks have supports for command line passed arguments.
   It is possible to define arguments for such tasks by running the build module with `-D<goalname>:<value>`.
   
   Where `<goalname>` is the name of the goal that holds the task and `<value>` the argument you want to pass to
   the task.
   
   For example, to call `"doc"` goal with `--source-code` and `--non-shared`, you can simply call
   `ceylon run mybuildmodule/x.y doc -Ddoc:--source-code -Ddoc:--non-shared`
   
   ```text
   ## ceylon.build: My Build Project
   # running goals: [doc] in order
   # running doc(--source-code, --non-shared)
   documenting: 'ceylon doc --source-code --non-shared mymodule'
   ## success - duration 1s
   ```
   """
shared package sample.ceylon.build.basics;
