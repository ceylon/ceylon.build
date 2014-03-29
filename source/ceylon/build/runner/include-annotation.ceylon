import ceylon.language.meta.declaration { FunctionOrValueDeclaration, ClassDeclaration, ValueDeclaration, Module }
import ceylon.build.task { GoalAnnotation, IncludeAnnotation }
import ceylon.language.meta { type }

shared [ValueDeclaration*] findAnnotatedIncludes(Module mod) {
    value annotatedIncludes = SequenceBuilder<ValueDeclaration>();
    for (pkg in mod.members) {
        value includesFromPackage = pkg.annotatedMembers<ValueDeclaration, IncludeAnnotation>();
        annotatedIncludes.appendAll(includesFromPackage);
    }
    return annotatedIncludes.sequence;
}

shared [<FunctionOrValueDeclaration->Object>*] goalDeclarationsFromIncludes(
    [ValueDeclaration*] annotatedIncludes) {
    value sb = SequenceBuilder<FunctionOrValueDeclaration -> Object>();
    for (include in annotatedIncludes) {
        value instance = include.apply<Object>().get();
        for (declaration in findClassMembersAnnotatedWithGoal(type(instance).declaration)) {
            sb.append(declaration -> instance);
        }
    }
    return sb.sequence;
}

[FunctionOrValueDeclaration*] findClassMembersAnnotatedWithGoal(ClassDeclaration instanceTypeDeclaration) {
    return instanceTypeDeclaration.annotatedMemberDeclarations<FunctionOrValueDeclaration, GoalAnnotation>();
}
