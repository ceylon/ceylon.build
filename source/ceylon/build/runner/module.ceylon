module ceylon.build.runner "1.1.1" {
    shared import ceylon.build.task "1.1.1";
    shared import ceylon.build.engine "1.1.1";
    import ceylon.collection "1.1.1";
    native("jvm") import com.redhat.ceylon.compiler.java "1.1.1";
    native("jvm") import org.jboss.modules "1.3.3.Final"; // needed for manual modules loading
}
