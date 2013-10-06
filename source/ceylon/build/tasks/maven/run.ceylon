import ceylon.build.task { Goal }
import ceylon.build.engine { build }
void run() {

    build {
        project = "Maven Test";
        Goal {
            name = "test";
            installJar {
                groupId = "org.jboss.shrinkwrap";
                artifactId = "shrinkwrap-impl-base";
                version = "1.2.0";
              //  overwrite = true;
            };
        }
    };
}