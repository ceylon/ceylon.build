import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}

"The annotation for [[dependsOn]]"
shared final annotation class DependsOnAnnotation(dependencies)
        satisfies SequencedAnnotation<DependsOnAnnotation, FunctionOrValueDeclaration> {
    
    "Dependencies to other [[goal]]s."
    shared FunctionOrValueDeclaration* dependencies;
}

"Annotation to specify current [[goal]] dependencies.
 
 This annotation can only be used on elements annotated with [[goal]]"
shared annotation DependsOnAnnotation dependsOn(
    
    "Dependencies to other [[goal]]s."
    FunctionOrValueDeclaration* dependencies)
        => DependsOnAnnotation(*dependencies);
