import ceylon.build.engine { build }
import ceylon.build.task { Goal }
import ceylon.build.tasks.misc { echo }

"Basic build example"
void run() {
    build {
        project = "My Build Project";
        interactive = true;
        Goal {
            name = "hello";
            echo {
                "Hello World";
            }
        }
    };
}