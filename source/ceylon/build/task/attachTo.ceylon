import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}

"The annotation for [[attachTo]]"
shared final annotation class AttachToAnnotation(phase)
        satisfies SequencedAnnotation<AttachToAnnotation, FunctionOrValueDeclaration> {
    
    "Phase (Goal) to which this [[goal]] should be attached."
    shared FunctionOrValueDeclaration phase;
}

"Annotation to attach current [[goal]] to another one.
 Destination [[goal]] will then have current [[goal]] as a dependency.
 
 This annotation can only be used on elements annotated with [[goal]]"
shared annotation AttachToAnnotation attachTo(
    
    "[[goal]] to which current [[goal]] should be attached."
    FunctionOrValueDeclaration phase)
        => AttachToAnnotation(phase);
