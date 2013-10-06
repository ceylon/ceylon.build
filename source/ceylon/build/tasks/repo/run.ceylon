import ceylon.build.task { Goal }
import ceylon.build.engine { build }
void run() {

    build {
        project = "Maven Test";
        Goal {
            name = "test";
            installMavenJar("org.jboss.shrinkwrap", "shrinkwrap-impl-base", "1.2.0");
        }
    };
}