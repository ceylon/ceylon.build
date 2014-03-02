import ceylon.build.engine { Goal }
import ceylon.language.meta { type }
import ceylon.language.meta.declaration { FunctionOrValueDeclaration, ClassDeclaration, ValueDeclaration, Module }
import ceylon.build.task { GoalAnnotation, IncludeAnnotation }

shared [ValueDeclaration*] findAnnotatedIncludes(Module mod) {
    value annotatedIncludes = SequenceBuilder<ValueDeclaration>();
    for (pkg in mod.members) {
        value includesFromPackage = pkg.annotatedMembers<ValueDeclaration, IncludeAnnotation>();
        annotatedIncludes.appendAll(includesFromPackage);
    }
    return annotatedIncludes.sequence;
}

shared {<Goal|InvalidGoalDeclaration>*} goalsDefinition(ValueDeclaration declaration) {
    value instance = declaration.apply<Object>().get();
    value instanceTypeDeclaration = type(instance).declaration;
    value goals = SequenceBuilder<Goal|InvalidGoalDeclaration>();
    value declarations = findClassMembersAnnotatedWithGoal(instanceTypeDeclaration);
    for (goalDeclaration in declarations) {
        goals.append(goalDefinition(goalDeclaration, instance));
    }
    return goals.sequence;
}

[FunctionOrValueDeclaration*] findClassMembersAnnotatedWithGoal(ClassDeclaration instanceTypeDeclaration) {
    return instanceTypeDeclaration.annotatedMemberDeclarations<FunctionOrValueDeclaration, GoalAnnotation>();
}
