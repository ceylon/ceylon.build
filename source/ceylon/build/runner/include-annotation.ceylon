import ceylon.language.meta.declaration { FunctionOrValueDeclaration, ClassDeclaration, ValueDeclaration, Module }
import ceylon.build.task { GoalAnnotation, IncludeAnnotation }
import ceylon.language.meta { type }
import ceylon.collection { ArrayList }

shared [ValueDeclaration*] findAnnotatedIncludes(Module mod) {
    value annotatedIncludes = ArrayList<ValueDeclaration>();
    for (pkg in mod.members) {
        value includesFromPackage = pkg.annotatedMembers<ValueDeclaration, IncludeAnnotation>();
        annotatedIncludes.addAll(includesFromPackage);
    }
    return annotatedIncludes.sequence();
}

shared [<FunctionOrValueDeclaration->Object>*] goalDeclarationsFromIncludes(
    [ValueDeclaration*] annotatedIncludes) {
    value sb = ArrayList<FunctionOrValueDeclaration -> Object>();
    for (include in annotatedIncludes) {
        value instance = include.apply<Object>().get();
        for (declaration in findClassMembersAnnotatedWithGoal(type(instance).declaration)) {
            sb.add(declaration -> instance);
        }
    }
    return sb.sequence();
}

[FunctionOrValueDeclaration*] findClassMembersAnnotatedWithGoal(ClassDeclaration instanceTypeDeclaration) {
    return instanceTypeDeclaration.annotatedMemberDeclarations<FunctionOrValueDeclaration, GoalAnnotation>();
}
