import ceylon.process { Process, createProcess, currentOutput, currentError }

shared class CeylonModuleTaskBuilder(
		String moduleName,
		String moduleVersion = "1.0.0",
		String moduleSrc = "source",
		String testModuleName = "test.``moduleName``",
		String testModuleVersion = moduleVersion,
		String testModuleSrc = "test-``moduleSrc``") {
	
	Boolean execute(Writer writer, String title, String cmd) {
		value commandToExecute = cmd.trimmed;
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
	
	Task createModuleCommandTask(String name, String title, String command, String? src = null, String? version = null) {
		Boolean process(String[] arguments, Writer writer) {
			String cmd = createCommand(command, moduleName, arguments, src, version);
			return execute(writer, title, cmd);
		}
		return Task(name, process);
	}
	
	shared Task createCompileTask(String name = "compile") {
		return createModuleCommandTask(name, "compiling", "compile", moduleSrc);
	}
	
	shared Task createCompileJsTask(String name = "compile-js") {
		return createModuleCommandTask(name, "compiling", "compile-js", moduleSrc);
	}
	
	shared Task createRunTask(String name = "run")  {
		return createModuleCommandTask(name, "running", "run", null, moduleVersion);
	}
	
	shared Task createRunJsTask(String name = "run-js")  {
		return createModuleCommandTask(name, "running", "run-js", null, moduleVersion);
	}
	
	shared Task createTestTask(String name = "test") {
		Boolean process(String[] arguments, Writer writer) {
			String compileCmd = createCommand("compile", testModuleName, arguments, testModuleSrc);
			if (!execute(writer, "compiling tests", compileCmd)) {
				return false;
			}
			String runCmd = createCommand("run", testModuleName, arguments, null, testModuleVersion);
			return execute(writer, "running tests", runCmd);
		}
		return Task(name, process);
	}
	
	shared Task createTestJsTask(String name = "test-js") {
		Boolean process(String[] arguments, Writer writer) {
			String compileCmd = createCommand("compile-js", testModuleName, arguments, testModuleSrc); 
			if (!execute(writer, "compiling tests", compileCmd)) {
				return false;
			}
			String runCmd = createCommand("run-js", testModuleName, arguments, null, testModuleVersion);
			return execute(writer, "running tests", runCmd);
		}
		return Task(name, process);
	}
	
	shared Task createDocTask(String name = "doc") {
		return createModuleCommandTask(name, "documenting", "doc", moduleSrc);
	}
}
