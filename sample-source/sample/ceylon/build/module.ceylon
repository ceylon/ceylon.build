"Sample ceylon.build module"
license("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
native("jvm")
module sample.ceylon.build "1.1.1" {
    shared import ceylon.build.task "1.1.1";
    import ceylon.build.engine "1.1.1";
    import ceylon.build.tasks.ceylon "1.1.1";
    import ceylon.build.tasks.commandline "1.1.1";
    import ceylon.build.tasks.file "1.1.1";
    import ceylon.build.tasks.misc "1.1.1";
}
