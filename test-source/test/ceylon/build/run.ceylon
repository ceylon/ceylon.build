import ceylon.test { suite }

"Run the module `test.ceylon.build`."
void run() {
    suite("ceylon.test",
            "tasks" -> testTasks,
            "tasks definitions" -> testTasksDefinitions,
            "tasks dependencies cycles" -> testDependenciesCycles,
            "tasks orchestration" -> testTasksOrchestration,
            "tasks execution" -> testTasksExecution);
}
