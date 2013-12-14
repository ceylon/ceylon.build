import ceylon.build.engine { build }
import ceylon.build.task { Goal }
import ceylon.build.tasks.misc { echo }

"Basic build example
 
 run this module with `ceylon run build --console` to start the console"
void run() {
    build {
        project = "My Build Project";
        Goal {
            name = "hello";
            echo("Hello World")
        }
    };
}