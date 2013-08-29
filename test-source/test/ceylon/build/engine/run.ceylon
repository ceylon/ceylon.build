import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
            "tasks name validation" -> testTasksNameValidation,
            "tasks duplication" -> testDuplicateTasks,
            "tasks dependencies cycles" -> testDependenciesCycles,
            "tasks orchestration" -> testTasksOrchestration,
            "tasks execution" -> testTasksExecution);
}
