"""
   Enables you to write Apache Ant scripts in Ceylon.
   
   It facilitates the use of Ant-types, Ant-tasks and Ant-processes being used within Ceylon.
   It is not intended to imitate Ant's `target` mechanism.
   Use the Ceylon based build tool [ceylon.build](https://github.com/loicrouchon/ceylon.build) for building with goals/targets.
   
   Can be used as a batch processor.
"""
by ("Henning Burdack")
license ("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module ceylon.build.tasks.ant "1.1.0"{
    shared import ceylon.collection "1.1.0";
    import java.base "7";
    import org.apache.ant.ant "1.9.2";
}
