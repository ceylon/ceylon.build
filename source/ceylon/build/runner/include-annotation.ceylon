import ceylon.build.engine { Goal }
import ceylon.language.meta { type }
import ceylon.language.meta.declaration { FunctionDeclaration, ClassDeclaration, ValueDeclaration, Module }
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

FunctionDeclaration[] findClassMembersAnnotatedWithGoal(ClassDeclaration instanceTypeDeclaration) {
    return instanceTypeDeclaration.annotatedMemberDeclarations<FunctionDeclaration, GoalAnnotation>();
}
