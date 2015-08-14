native("jvm")
module ceylon.build.runner "1.1.1" {
    shared import ceylon.build.task "1.1.1";
    shared import ceylon.build.engine "1.1.1";
    import ceylon.collection "1.1.1";
    import com.redhat.ceylon.compiler.java "1.1.1";
    import org.jboss.modules "1.3.3.Final"; // needed for manual modules loading
    import java.base "7";
    import ceylon.interop.java "1.1.1";
    import com.redhat.ceylon.common "1.1.1";
}
