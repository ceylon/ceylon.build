import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { moduleVersion }

test void shouldReturnModuleWithDefaultVersionString() {
    assertEquals {
        expected = "mymodule";
        actual = moduleVersion("mymodule");
    };
}

test void shouldReturnModuleWithVersionString() {
    assertEquals {
        expected = "mymodule/1.2";
        actual = moduleVersion("mymodule", "1.2");
    };
}
