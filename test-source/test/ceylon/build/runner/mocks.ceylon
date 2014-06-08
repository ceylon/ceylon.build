import ceylon.language {
    AnnotationType=Annotation
}
import ceylon.language.meta.declaration {
    Import,
    FunctionDeclaration,
    NestableDeclaration,
    ValueDeclaration,
    ClassOrInterfaceDeclaration,
    Package,
    Module,
    AliasDeclaration,
    OpenType,
    FunctionOrValueDeclaration,
    TypeParameter,
    SetterDeclaration,
    ClassDeclaration
}
import ceylon.language.meta.model {
    Method,
    Type,
    Function,
    Value,
    Attribute
}
import ceylon.collection { ArrayList }

Module mockModule({Package*} packages = []) {
    object mod satisfies Module {
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType => notImplemented;
        
        shared actual Import[] dependencies = [];
        
        shared actual Package? findImportedPackage(String name) => notImplemented;
        
        shared actual Package? findPackage(String name) => notImplemented;
        
        shared actual Package[] members = packages.sequence;
        
        shared actual String name => notImplemented;
        
        shared actual String qualifiedName => notImplemented;
        
        shared actual String version => notImplemented;
        
        shared actual Resource? resourceByPath(String path) => notImplemented;
    }
    return mod;
}

Package mockPackage({NestableDeclaration*} declarations = []) {
    object pkg satisfies Package {
        
        Boolean hasAnnotation<Annotation>(AnnotationType[] annotations) {
            for (annotation in annotations) {
                if (is Annotation annotation) {
                    return true;
                }
            }
            return false;
        }
        
        shared actual Kind[] annotatedMembers<Kind, Annotation>()
                given Kind satisfies NestableDeclaration
                given Annotation satisfies AnnotationType {
            value members = ArrayList<Kind>();
            for (declaration in declarations) {
                [AnnotationType*] annotations = declaration.annotations<AnnotationType>();
                if (is Kind declaration, hasAnnotation<Annotation>(annotations)) {
                    members.add(declaration);
                }
            }
            return members.sequence;
        }
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType => notImplemented;
        
        shared actual Module container => notImplemented;
        
        shared actual AliasDeclaration? getAlias(String name) => notImplemented;
        
        shared actual ClassOrInterfaceDeclaration? getClassOrInterface(String name) => notImplemented;
        
        shared actual FunctionDeclaration? getFunction(String name) => notImplemented;
        
        shared actual Kind? getMember<Kind>(String name)
                given Kind satisfies NestableDeclaration => notImplemented;
        
        shared actual ValueDeclaration? getValue(String name) => notImplemented;
        
        shared actual Kind[] members<Kind>()
                given Kind satisfies NestableDeclaration => notImplemented;
        
        shared actual String name => notImplemented;
        
        shared actual String qualifiedName => notImplemented;
        
        shared actual Boolean shared => notImplemented;
        
        
    }
    return pkg;
}

FunctionDeclaration mockFunctionDeclaration(Annotation* associatedAnnotations) {
    object functionDeclaration satisfies FunctionDeclaration {
        
        shared actual Boolean actual => notImplemented;
        
        shared actual Boolean annotation => notImplemented;
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType =>
                [ for (annotation in associatedAnnotations)
                    if (is Annotation annotation)
                      annotation];
        
        shared actual Function<Return,Arguments> apply<Return, Arguments>(Type<Anything>* typeArguments)
                given Arguments satisfies Anything[] => notImplemented;
        
        shared actual NestableDeclaration|Package container => notImplemented;
        
        shared actual Module containingModule => notImplemented;
        
        shared actual Package containingPackage => notImplemented;
        
        shared actual Boolean default => notImplemented;
        
        shared actual Boolean defaulted => notImplemented;
        
        shared actual Boolean formal => notImplemented;
        
        shared actual FunctionOrValueDeclaration? getParameterDeclaration(String name) => notImplemented;
        
        shared actual TypeParameter? getTypeParameterDeclaration(String name) => notImplemented;
        
        shared actual Method<Container,Return,Arguments> memberApply<Container, Return, Arguments>(Type<Container> containerType, Type<Anything>* typeArguments)
                given Arguments satisfies Anything[] => notImplemented;
        
        shared actual String name => notImplemented;
        
        shared actual OpenType openType => notImplemented;
        
        shared actual Boolean parameter => notImplemented;
        
        shared actual FunctionOrValueDeclaration[] parameterDeclarations => notImplemented;
        
        shared actual String qualifiedName => notImplemented;
        
        shared actual Boolean shared => notImplemented;
        
        shared actual Boolean toplevel => notImplemented;
        
        shared actual TypeParameter[] typeParameterDeclarations => notImplemented;
        
        shared actual Boolean variadic => notImplemented;
    }
    return functionDeclaration;
}

ValueDeclaration mockValueDeclaration(Annotation* associatedAnnotations) {
    object valueDeclaration satisfies ValueDeclaration {

        shared actual Boolean actual => notImplemented;
        
        shared actual Boolean objectValue => notImplemented;
        
        shared actual ClassDeclaration? objectClass => notImplemented;
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType =>
                [ for (annotation in associatedAnnotations)
                    if (is Annotation annotation)
                      annotation];
        
        shared actual Value<Get,Set> apply<Get, Set>() => notImplemented;
        
        shared actual NestableDeclaration|Package container => notImplemented;
        
        shared actual Module containingModule => notImplemented;
        
        shared actual Package containingPackage => notImplemented;
        
        shared actual Boolean default => notImplemented;
        
        shared actual Boolean defaulted => notImplemented;
        
        shared actual Boolean formal => notImplemented;
        
        shared actual Attribute<Container,Get,Set> memberApply<Container, Get, Set>(Type<Container> containerType) => notImplemented;
        
        shared actual Anything memberSet(Object container, Anything newValue) => notImplemented;
        
        shared actual String name => notImplemented;
        
        shared actual OpenType openType => notImplemented;
        
        shared actual Boolean parameter => notImplemented;
        
        shared actual String qualifiedName => notImplemented;
        
        shared actual SetterDeclaration setter => notImplemented;
        
        shared actual Boolean shared => notImplemented;
        
        shared actual Boolean toplevel => notImplemented;
        
        shared actual Boolean variable => notImplemented;
        
        shared actual Boolean variadic => notImplemented;
    }
    return valueDeclaration;
}

"Evaluate `nothing` and throws if called.
 Useful to remove `nothing` warning in mocking context"
Nothing notImplemented => `nothing`.get();
