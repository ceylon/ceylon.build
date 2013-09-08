import ceylon.test { suite }

void run() {
    suite("ceylon.build.engine",
        "goals" -> shouldHaveGivenName,
        "goals equality" -> goalsWithSameNamesAreEquals,
        "goals inequality" -> goalsWithDifferentNamesAreNotEquals,
        "goals hash equality" -> goalsWithSameNamesHaveSameHash,
        "goals hash inequality" -> goalsWithDifferentNamesHashHaveDifferentHash);
}