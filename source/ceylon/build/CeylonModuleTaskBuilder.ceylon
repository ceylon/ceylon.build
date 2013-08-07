import ceylon.process { Process, createProcess, currentOutput, currentError }

shared class CeylonModuleTaskBuilder(
        String moduleName,
        String moduleVersion = "1.0.0",
        String moduleSrc = "source",
        String testModuleName = "test.``moduleName``",
        String testModuleVersion = moduleVersion,
        String testModuleSrc = "test-``moduleSrc``") {
    
    Boolean execute(Writer writer, String title, String cmd) {
        value commandToExecute = cmd.trimTrailingCharacters(" ");
        writer.info("``title``: '``commandToExecute``'");
        Process process = createProcess {
            command = commandToExecute;
            output = currentOutput;
            error = currentError;
        };
        process.waitForExit();
        if (exists exitCode = process.exitCode) {
            return exitCode == 0;
        }
        return false;
    }
    
    
    String createCommand(String command, String moduleName, String[] arguments, String? src = null, String? version = null) {
        String moduleId;
        if (exists version) {
            moduleId = "``moduleName``/``moduleVersion``";   
        } else {
            moduleId = moduleName;
        }
        String sources;
        if (exists src) {
            sources = " --src=``src``";
        } else {
            sources = "";
        }
        String args;
        if (nonempty arguments) {
            args = " ``" ".join(arguments)``";
        } else {
            args = "";
        }
        return "ceylon ``command`` ``moduleId````sources````args``";
    }
    
    Task createModuleCommandTask(String taskName, String title, String command, String? src = null, String? version = null) {
        object task satisfies Task {
            name = taskName;
            
            shared actual Boolean process(String[] arguments, Writer writer) {
                String cmd = createCommand(command, moduleName, arguments, src, version);
                return execute(writer, title, cmd);
            }
        }
        return task;
    }
    
    shared Task createCompileTask(String taskName = "compile") {
        return createModuleCommandTask(taskName, "compiling", "compile", moduleSrc);
    }
    
    shared Task createCompileJsTask(String taskName = "compile-js") {
        return createModuleCommandTask(taskName, "compiling", "compile-js", moduleSrc);
    }
    
    shared Task createRunTask(String taskName = "run")  {
        return createModuleCommandTask(taskName, "running", "run", null, moduleVersion);
    }
    
    shared Task createRunJsTask(String taskName = "run-js")  {
        return createModuleCommandTask(taskName, "running", "run-js", null, moduleVersion);
    }
    
    shared Task createTestTask(String taskName = "test") {
        object test satisfies Task {
            name = taskName;
            
            shared actual Boolean process(String[] arguments, Writer writer) {
                String compileCmd = createCommand("compile", testModuleName, arguments, testModuleSrc);
                if (!execute(writer, "compiling tests", compileCmd)) {
                    return false;
                }
                String runCmd = createCommand("run", testModuleName, arguments, null, testModuleVersion);
                return execute(writer, "running tests", runCmd);
            }
        }
        return test;
    }
    
    shared Task createTestJsTask(String taskName = "test-js") {
        object test satisfies Task {
            name = taskName;
            
            shared actual Boolean process(String[] arguments, Writer writer) {
                String compileCmd = createCommand("compile-js", testModuleName, arguments, testModuleSrc); 
                if (!execute(writer, "compiling tests", compileCmd)) {
                    return false;
                }
                String runCmd = createCommand("run-js", testModuleName, arguments, null, testModuleVersion);
                return execute(writer, "running tests", runCmd);
            }
        }
        return test;
    }
    
    shared Task createDocTask(String taskName = "doc") {
        return createModuleCommandTask(taskName, "documenting", "doc", moduleSrc);
    }
}
