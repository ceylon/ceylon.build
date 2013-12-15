"Verbose mode"
shared interface VerboseMode {}

"All verbose modes for jvm backend compilation / execution"
shared interface AllVerboseModes {}

"Verbose modes for jvm backend compilation"
shared interface CompileVerboseMode of loader | ast | code | cmr | benchmark satisfies VerboseMode {}

"Verbose modes for js backend compilation"
shared interface CompileJsVerboseMode of loader satisfies VerboseMode {}

"Verbose modes for jvm backend execution"
shared interface RunVerboseMode of cmr satisfies VerboseMode {}

"All verbose modes"
shared object all satisfies AllVerboseModes {}
"verbose mode: loader"
shared object loader satisfies CompileVerboseMode & CompileJsVerboseMode { string => "loader"; }
"verbose mode: ast"
shared object ast satisfies CompileVerboseMode { string => "ast"; }
"verbose mode: code"
shared object code satisfies CompileVerboseMode { string => "code"; }
"verbose mode: cmrloader"
shared object cmr satisfies CompileVerboseMode & RunVerboseMode{ string => "cmr"; }
"verbose mode: benchmark"
shared object benchmark satisfies CompileVerboseMode { string => "benchmark"; }
