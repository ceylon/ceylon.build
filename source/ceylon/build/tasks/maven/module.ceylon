license("http://www.apache.org/licenses/LICENSE-2.0")
module ceylon.build.tasks.maven "0.1" {
    import ceylon.file "0.6.1";
    
    shared import ceylon.build.task "0.1";
    import ceylon.build.engine "0.1";
    
    shared import 'org.sonatype.aether.aether-connector-wagon' '1.13.1';
    shared import 'org.sonatype.aether.aether-api' '1.13.1';
    shared import 'org.sonatype.aether.aether-impl' '1.13.1';
    shared import 'org.sonatype.aether.aether-util' '1.13.1';
    shared import 'org.apache.maven.maven-aether-provider' '3.0.4';
    shared import 'org.apache.maven.wagon.wagon-http-lightweight' '2.2';

    import java.base "7";
}
