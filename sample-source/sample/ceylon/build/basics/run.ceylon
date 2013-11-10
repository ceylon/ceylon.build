import ceylon.build.engine { build }
import ceylon.build.task { Goal }
import ceylon.build.tasks.ceylon { compile, document }

"Basic build example"
void run() {
    build {
        project = "My Build Project";
        Goal {
            name = "compile";
            compile {
                modules = "mymodule";
            }
        },
        Goal {
            name = "doc";
            document {
                modules = "mymodule";
            }
        }
    };
}