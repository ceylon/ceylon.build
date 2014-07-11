import ceylon.language.meta.declaration {
    ValueDeclaration
}

"The annotation for [[include]]"
shared final annotation class IncludeAnnotation()
        satisfies OptionalAnnotation<IncludeAnnotation, ValueDeclaration> {
}

"Annotation to import annotated object [[goal]]s"
shared annotation IncludeAnnotation include() => IncludeAnnotation();
