import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
            "tasks" -> testTasks,
            "tasks definitions" -> testTasksDefinitions,
            "tasks name validation" -> testTasksNameValidation,
            "tasks duplication" -> testDuplicateTasks,
            "tasks dependencies cycles" -> testDependenciesCycles,
            "tasks orchestration" -> testTasksOrchestration,
            "tasks execution" -> testTasksExecution);
}
