import ceylon.build.task { Writer }
import ceylon.build.tasks.commandline { executeCommand, reportOutcome }
import ceylon.collection { HashMap }
import com.redhat.ceylon.common.tools { CeylonTool, CeylonToolLoader }
import org.jboss.modules {
    JBossModule = Module { ceylonModuleLoader = callerModuleLoader },
    ModuleIdentifier { createModuleIdentifier = create }
}

"Executes ceylon command using given ceylon executable or `CeylonTool` if none is given"
void execute(Writer writer, String title, String? ceylon, [String+] arguments) {
    Integer exitCode;
    if (exists ceylon) {
        exitCode = executeInNewProcess(writer, title, ceylon, arguments);
    } else {
        exitCode = executeWithCurrentCeylonRuntime(arguments);
    }
    reportOutcome(exitCode, ceylon else "<ceylon>", arguments);
}

"Executes ceylon command with given ceylon executable in a new process"
Integer executeInNewProcess(Writer writer, String title, String ceylon, [String+] arguments) {
    value commandToExecute = [ceylon, *arguments];
    writer.info("``title``: '``" ".join(commandToExecute)``'");
    return executeCommand(ceylon, arguments) else 0;
}

"Executes ceylon command using `CeylonTool`"
Integer executeWithCurrentCeylonRuntime([String+] arguments) {
    CeylonTool tool = CeylonTool();
    assert (exists mod = commandToModule.get(arguments.first));
    tool.setToolLoader(loadJavaModule(mod.name, mod.version));
    return tool.bootstrap(*arguments);
}

class Module(shared String name, shared String? version = null) {}
Module jvmCompiler = Module("com.redhat.ceylon.compiler.java", language.version);
Module jsCompiler = Module("com.redhat.ceylon.compiler.js", language.version);
Module ceylonRuntime = Module("ceylon.runtime", language.version);
Map<String, Module> commandToModule = HashMap {
    entries = {
        "compile" -> jvmCompiler,
        "compile-js" -> jsCompiler,
        "doc" -> jvmCompiler,
        "run" -> ceylonRuntime,
        "run-js" -> jsCompiler,
        "test" -> ceylonRuntime,
        "test-js" -> jsCompiler
    };
};

CeylonToolLoader loadJavaModule(String name, String? version) {
    value identifier = createModuleIdentifier(name, version);
    value jbossModule = ceylonModuleLoader.loadModule(identifier);
    value classLoader = jbossModule.classLoader;
    return CeylonToolLoader(classLoader);
}
