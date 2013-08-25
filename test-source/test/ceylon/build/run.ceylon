import ceylon.test { suite }
import test.ceylon.build.tasks.ceylon { testCommandsBuilder }

"Run the module `test.ceylon.build`."
void run() {
    suite("ceylon.test",
            "tasks" -> testTasks,
            "tasks definitions" -> testTasksDefinitions,
            "tasks name validation" -> testTasksNameValidation,
            "tasks duplication" -> testDuplicateTasks,
            "tasks dependencies cycles" -> testDependenciesCycles,
            "tasks orchestration" -> testTasksOrchestration,
            "tasks execution" -> testTasksExecution,
            "ceylon commands" -> testCommandsBuilder);
}
