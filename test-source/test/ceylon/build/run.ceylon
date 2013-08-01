import ceylon.test { suite }

"Run the module `test.ceylon.build`."
void run() {
    suite("ceylon.test",
            "tasks" -> testTasks,
            "dependencies cycles" -> testDependenciesCycles);
}
