import ceylon.build.task { goal }
import ceylon.build.tasks.ceylon { ceylon }

shared goal void compile() {
    ceylon.compile {
        modules = "mymodule";
    };
}

shared goal void doc() {
    ceylon.document {
        modules = "mymodule";
    };
}
