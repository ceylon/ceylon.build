import ceylon.language.meta.declaration { FunctionDeclaration }
import ceylon.test { test, assertEquals }
import ceylon.build.runner { goalName }
import ceylon.build.task { goal, GoalAnnotation }

test void shouldUseFunctionDeclarationNameAsGoalName() {
    FunctionDeclaration declaration = mockFunctionDeclaration("functionName");
    GoalAnnotation annotation = goal();
    assertEquals(goalName(annotation, declaration), "functionName");
}

test void shouldUseNamedDefinedInGoalAnnotationAsGoalName() {
    FunctionDeclaration declaration = mockFunctionDeclaration("functionName");
    GoalAnnotation annotation = goal("goalName");
    assertEquals(goalName(annotation, declaration), "goalName");
}
