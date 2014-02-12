import ceylon.test { test, assertEquals }
import ceylon.build.runner { isFunctionWithoutParameters, functionModelToFunction }
import ceylon.build.task { Context, Writer }
import ceylon.language.meta.declaration { FunctionDeclaration }

Context mockContext() {
    object writer satisfies Writer {
        shared actual void error(String message) {}
        
        shared actual void info(String message) {}
    }
    return Context([], writer);
}

variable Integer tasksFromFunctionCallCounter = 0;
void voidFunction() => tasksFromFunctionCallCounter++;

test void shouldEmbedFunctionInTasks() {
    tasksFromFunctionCallCounter = 0;
    value task = functionModelToFunction(`voidFunction`);
    assertEquals(tasksFromFunctionCallCounter, 0);
    task();
    assertEquals(tasksFromFunctionCallCounter, 1);
}

class TestVoidMethod() {
    shared variable Integer callCounter = 0;
    
    shared void method() => callCounter++;
}

test void shouldEmbedcallCounterMethodInTasks() {
    value obj = TestVoidMethod();
    value task = functionModelToFunction(`TestVoidMethod.method`.bind(obj));
    assertEquals(obj.callCounter, 0);
    task();
    assertEquals(obj.callCounter, 1);
}

void voidWithNoParametersFunction() {}
String returnTypeWithNoParametersFunction() => "";
void voidWithParametersFunction(String param) {}
[Element*] voidWithTypeParameterFunction<Element>() => [];

test void shouldRecognizeVoidWithNoParametersFunction() {
    assertRecognizeVoidWithNoParametersFunction(`function voidWithNoParametersFunction`, true);
    assertRecognizeVoidWithNoParametersFunction(`function returnTypeWithNoParametersFunction`, true);
}

test void shouldNotRecognizeVoidWithNoParametersFunction() {
    assertRecognizeVoidWithNoParametersFunction(`function voidWithParametersFunction`, false);
    assertRecognizeVoidWithNoParametersFunction(`function voidWithTypeParameterFunction`, false);
}

void assertRecognizeVoidWithNoParametersFunction(FunctionDeclaration declaration, Boolean expected) {
    assertEquals(isFunctionWithoutParameters(declaration), expected);
}
