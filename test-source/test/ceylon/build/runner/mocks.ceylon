import ceylon.language { AnnotationType = Annotation }
import ceylon.language.meta.declaration { Import, FunctionDeclaration, NestableDeclaration, ValueDeclaration, ClassOrInterfaceDeclaration, Package, Module, AliasDeclaration, OpenType, FunctionOrValueDeclaration, TypeParameter }
import ceylon.language.meta.model { Method, Type, Function }

Module mockModule({Package*} packages = []) {
    object mod satisfies Module {
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType => nothing;
        
        shared actual Import[] dependencies = [];
        
        shared actual Package? findImportedPackage(String name) => nothing;
        
        shared actual Package? findPackage(String name) => nothing;
        
        shared actual Package[] members = packages.sequence;
        
        shared actual String name => nothing;
        
        shared actual String qualifiedName => nothing;
        
        shared actual String version => nothing;
        
        
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
                given Kind satisfies NestableDeclaration {
            value members = SequenceBuilder<Kind>();
            for (declaration in declarations) {
                [AnnotationType*] annotations = declaration.annotations<AnnotationType>();
                if (is Kind declaration, hasAnnotation<Annotation>(annotations)) {
                    members.append(declaration);
                }
            }
            return members.sequence;
        }
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType => nothing;
        
        shared actual Module container => nothing;
        
        shared actual AliasDeclaration? getAlias(String name) => nothing;
        
        shared actual ClassOrInterfaceDeclaration? getClassOrInterface(String name) => nothing;
        
        shared actual FunctionDeclaration? getFunction(String name) => nothing;
        
        shared actual Kind? getMember<Kind>(String name)
                given Kind satisfies NestableDeclaration => nothing;
        
        shared actual ValueDeclaration? getValue(String name) => nothing;
        
        shared actual Kind[] members<Kind>()
                given Kind satisfies NestableDeclaration => nothing;
        
        shared actual String name => nothing;
        
        shared actual String qualifiedName => nothing;
        
        shared actual Boolean shared => nothing;
        
        
    }
    return pkg;
}

FunctionDeclaration mockFunctionDeclaration(Annotation* associatedAnnotations) {
    object functionDeclaration satisfies FunctionDeclaration {
        
        shared actual Boolean actual => nothing;
        
        shared actual Boolean annotation => nothing;
        
        shared actual Annotation[] annotations<Annotation>()
                given Annotation satisfies AnnotationType =>
                [ for (annotation in associatedAnnotations)
                    if (is Annotation annotation)
                      annotation];
        
        shared actual Function<Return,Arguments> apply<Return, Arguments>(Type<Anything>* typeArguments)
                given Arguments satisfies Anything[] => nothing;
        
        shared actual NestableDeclaration|Package container => nothing;
        
        shared actual Module containingModule => nothing;
        
        shared actual Package containingPackage => nothing;
        
        shared actual Boolean default => nothing;
        
        shared actual Boolean defaulted => nothing;
        
        shared actual Boolean formal => nothing;
        
        shared actual FunctionOrValueDeclaration? getParameterDeclaration(String name) => nothing;
        
        shared actual TypeParameter? getTypeParameterDeclaration(String name) => nothing;
        
        shared actual Method<Container,Return,Arguments> memberApply<Container, Return, Arguments>(Type<Container> containerType, Type<Anything>* typeArguments)
                given Arguments satisfies Anything[] => nothing;
        
        shared actual String name => nothing;
        
        shared actual OpenType openType => nothing;
        
        shared actual Boolean parameter => nothing;
        
        shared actual FunctionOrValueDeclaration[] parameterDeclarations => nothing;
        
        shared actual String qualifiedName => nothing;
        
        shared actual Boolean shared => nothing;
        
        shared actual Boolean toplevel => nothing;
        
        shared actual TypeParameter[] typeParameterDeclarations => nothing;
        
        shared actual Boolean variadic => nothing;
    }
    return functionDeclaration;
}