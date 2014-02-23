import ceylon.language.meta.declaration { FunctionOrValueDeclaration }

shared final class InvalidGoalDeclaration(declaration) {
    
    shared FunctionOrValueDeclaration declaration;
    
    hash => declaration.hash;
    
    shared actual Boolean equals(Object that) {
        if (is InvalidGoalDeclaration that) {
            return declaration.equals(that.declaration);
        }
        return false;
    }
    
    string => "InvalidGoalDeclaration[``declaration``]";
}