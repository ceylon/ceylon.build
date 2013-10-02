import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
    "goals" -> shouldHaveGivenName,
    "goals equality" -> goalsWithSameNamesAreEquals,
    "goals inequality" -> goalsWithDifferentNamesAreNotEquals,
    "goals hash equality" -> goalsWithSameNamesHaveSameHash,
    "goals hash inequality" -> goalsWithDifferentNamesHashHaveDifferentHash,
    "goal groups" -> goalGroupShouldHaveGivenName,
    "goal groups equality" -> goalGroupsWithSameNamesAreEquals,
    "goal groups inequality" -> goalGroupsWithDifferentNamesAreNotEquals,
    "goal groups hash equality" -> goalGroupsWithSameNamesHaveSameHash,
    "goal groups hash inequality" -> goalGroupsWithDifferentNamesHashHaveDifferentHash,
    "goal groups contained goals" -> shouldHoldGoals);
}