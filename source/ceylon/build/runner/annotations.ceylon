import ceylon.language.meta.declaration { Module }
import ceylon.build.engine { GoalDefinitionsBuilder, Goal }

GoalDefinitionsBuilder|[InvalidGoalDeclaration+] readAnnotations(Module mod) {
    value invalidDeclarations = SequenceBuilder<InvalidGoalDeclaration>();
    value goals = GoalDefinitionsBuilder();
    for (declaration in findPackageMembersAnnotatedWithGoals(mod)) {
        value goal = goalDefinition(declaration);
        fillGoalsAndInvalidDeclarations(goal, goals, invalidDeclarations);
    }
    for (declaration in findAnnotatedIncludes(mod)) {
        for (goal in goalsDefinition(declaration)) {
            fillGoalsAndInvalidDeclarations(goal, goals, invalidDeclarations);
        }
    }
    if (nonempty seq = invalidDeclarations.sequence) {
        return seq;
    }
    return goals;
}

void fillGoalsAndInvalidDeclarations(
    Goal|InvalidGoalDeclaration goal,
    GoalDefinitionsBuilder goals,
    SequenceBuilder<InvalidGoalDeclaration> invalidDeclarations) {
    switch (goal)
    case (is Goal) {
        goals.add(goal);
    } case (is InvalidGoalDeclaration) {
        invalidDeclarations.append(goal);
    }
}
