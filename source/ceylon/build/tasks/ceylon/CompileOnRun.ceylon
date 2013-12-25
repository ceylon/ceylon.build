
"Compile on run flag"
shared interface CompileOnRun of never | once | force | check {}
"Never attempt to compile"
shared object never satisfies CompileOnRun { string => "never"; }
"Compile only if not compiled"
shared object once satisfies CompileOnRun { string => "once"; }
"Always compile"
shared object force satisfies CompileOnRun { string => "force"; }
"Check and compile if needed"
shared object check satisfies CompileOnRun { string => "check"; }
