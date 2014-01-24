import ceylon.build.task { goal }
import ceylon.build.tasks.misc { echo }

"Basic build example
 
 run this module with `ceylon run build --console` to start the console"
shared goal void hello() {
    echo("Hello World");
}