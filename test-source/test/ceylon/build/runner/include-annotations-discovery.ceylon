import ceylon.build.runner {
	findTopLevelAnnotatedGoals,
	findAnnotatedIncludes
}
import ceylon.collection {
	HashSet
}
import ceylon.language.meta.declaration {
	Module,
	ValueDeclaration
}
import ceylon.test {
	test,
	assertEquals
}

import mock.ceylon.build.runner.mock4 {
	include1,
	include2
}
import mock.ceylon.build.runner.mock4.subpackage {
	include3
}

test void shouldNotFindIncludeAnnotatedValuesIfNoPackage() {
    Module mod = `module mock.ceylon.build.runner.mock1`;
    value results = findTopLevelAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindIncludeAnnotatedValuesInEmptyPackages() {
    Module mod = `module mock.ceylon.build.runner.mock2`;
    value results = findTopLevelAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldNotFindIncludeAnnotatedValuesIfNoValuesAnnotatedWithIt() {
    Module mod = `module mock.ceylon.build.runner.mock3`;
    value results = findTopLevelAnnotatedGoals(mod);
    assertEquals(results, []);
}

test void shouldFindIncludeAnnotatedValues() {
    Module mod = `module mock.ceylon.build.runner.mock4`;
    value results = [].chain(findAnnotatedIncludes(mod));
    value expected = [`value include1`, `value include2`, `value include3`];
    containSameElements(results, expected);
}

void containSameElements({ValueDeclaration*} actual, {ValueDeclaration*} expected) {
    assertEquals(HashSet { elements = actual; } , HashSet { elements = expected; });
}