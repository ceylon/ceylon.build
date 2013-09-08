import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
            "goals name validation" -> testGoalNameValidation,
            "goals duplication" -> testDuplicateGoals,
            "goals dependencies cycles" -> testDependenciesCycles,
            "goals orchestration" -> testGoalsOrchestration,
            "goals execution" -> testGoalsExecution);
}
