import ceylon.language.meta.declaration { Module }
import ceylon.test { test, assertEquals }
import ceylon.build.runner { findTopLevelAnnotatedGoals }
import mock.ceylon.build.runner.mock6 { goal1, goal2, goal4 }
import mock.ceylon.build.runner.mock6.subpackage { goal3, goal5, goal6 }

test void shouldNotFindGoalAnnotatedFunctionsOrValuesIfNoPackage() {
    Module mod = `module mock.ceylon.build.runner.mock1`;
    value results = findTopLevelAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsOrValuesInEmptyPackages() {
    Module mod = `module mock.ceylon.build.runner.mock2`;
    value results = findTopLevelAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindGoalAnnotatedFunctionsOrValuesIfNoFunctionsOrValuesAnnotatedWithIt() {
    Module mod = `module mock.ceylon.build.runner.mock5`;
    value results = findTopLevelAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldFindGoalAnnotatedFunctionsAndValues() {
    Module mod = `module mock.ceylon.build.runner.mock6`;
    value results = [].chain(findTopLevelAnnotatedGoals(mod));
    value expected = [`function goal1`, `function goal2`, `value goal4`, `function goal3`, `value goal5`, `value goal6`];
    assertEquals(results, expected);
}
