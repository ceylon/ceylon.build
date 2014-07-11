import ceylon.build.task {
    Context,
    context,
    clearTaskContext,
    Writer,
    setContextForTask
}
import ceylon.test {
    assertEquals,
    test,
    assertThatException,
    beforeTest
}

beforeTest void resetContext() {
    clearTaskContext();
}

test void shouldNotBeAbleToAccessContext() {
    assertThatException(contextWrapper)
            .hasType(`Exception`)
            .hasMessage("Context accessed from outside a goal");
}

test void shouldBeAbleToAccessContext() {
    [String*] arguments = ["my", "arguments"];
    setContextForTask(arguments, writer);
    assertEquals(contextWrapper().arguments, arguments);
    assertEquals(contextWrapper().writer, writer);
}

test void shouldHaveADifferentContextAfterClearAndSet() {
    [String*] arguments1 = ["my", "arguments", "1"];
    [String*] arguments2 = ["my", "arguments", "2"];
    for (arguments in [arguments1, arguments2]) {
        setContextForTask(arguments, writer);
        assertEquals(contextWrapper().arguments, arguments);
        assertEquals(contextWrapper().writer, writer);
        clearTaskContext();
        assertThatException(contextWrapper)
                .hasType(`Exception`)
                .hasMessage("Context accessed from outside a goal");
    }
}

object writer satisfies Writer {
    
    shared actual void error(String message) {}
    
    shared actual void info(String message) {}
    
}

Context contextWrapper() => context;
