import ceylon.build.task { goal }
import ceylon.build.tasks.ceylon { compileModule = compile, document }

shared goal void compile() {
    compileModule {
        modules = "mymodule";
    };
}

shared goal void doc() {
    document {
        modules = "mymodule";
    };
}
