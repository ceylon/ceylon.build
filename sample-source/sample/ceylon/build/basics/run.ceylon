import ceylon.build.engine { build }
import ceylon.build.task { Goal }
import ceylon.build.tasks.ceylon { compile, document }

void run() {
    build {
        project = "My Build Project";
        Goal {
            name = "compile";
            compile {
                compilationUnits = "mymodule";
            };
        },
        Goal {
            name = "doc";
            document {
                modules = "mymodule";
            };
        }
    };
}