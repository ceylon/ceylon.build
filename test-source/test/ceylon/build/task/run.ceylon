import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
        "tasks" -> shouldHaveGivenName,
        "tasks equality" -> tasksWithSameNamesAreEquals,
        "tasks inequality" -> tasksWithDifferentNamesAreNotEquals,
        "tasks hash equality" -> tasksWithSameNamesHaveSameHash,
        "tasks hash inequality" -> tasksWithDifferentNamesHashHaveDifferentHash);
}