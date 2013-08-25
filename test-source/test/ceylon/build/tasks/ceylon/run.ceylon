import ceylon.test { suite }

void run() {
    suite("ceylon.build.tasks.ceylon",
            "ceylon commands" -> testCommandsBuilder);
}