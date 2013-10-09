import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
    "goals should have a name" -> shouldHaveGivenName,
    "goals should have a task" -> shouldHoldGivenTask,
    "goals should have no dependencies by default" -> shouldHaveNoDependenciesByDefault,
    "goals should hold dependencies when given" -> shouldHoldDependencies,
    "goal groups should have a name" -> goalGroupShouldHaveGivenName,
    "goal groups should hold inner goals and goal groups" -> shouldHoldGoalsAndGoalGroups);
}