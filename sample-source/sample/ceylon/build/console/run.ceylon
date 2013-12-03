import ceylon.build.task { Goal }
import ceylon.build.tasks.misc { echo }
import ceylon.build.tasks.commandline { console }

Goal echoGoal = Goal {
    name = "echo";
    echo {
        "Hello World";
    }
};

"Basic build example"
void run() {
    console(`module sample.ceylon.build`);
}