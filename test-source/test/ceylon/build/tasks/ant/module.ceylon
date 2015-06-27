"""
   Tests the module `ceylon.build.tasks.ant`.
"""
by ("Henning Burdack")
license ("[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)")
module test.ceylon.build.tasks.ant "1.1.1" {
    import ceylon.build.tasks.ant "1.1.1";
    import ceylon.build.tasks.file "1.1.1";
    native("jvm") import ceylon.file "1.1.1";
    import ceylon.test "1.1.1";
    native("jvm") import "org.apache.ant:ant-commons-net" "1.9.4";
    native("jvm") import "org.apache.ivy:ivy" "2.3.0";
}
