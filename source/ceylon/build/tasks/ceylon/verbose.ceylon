
"All verbose modes for jvm backend compilation / execution"
shared interface AllVerboseModes {}
"All verbose modes"
shared object all satisfies AllVerboseModes {}

"Verbose modes for jvm backend compilation"
shared interface CompileVerboseMode of loader | ast | code | cmrloader | benchmark {}

"verbose mode: loader"
shared object loader satisfies CompileVerboseMode { string => "loader"; }
"verbose mode: ast"
shared object ast satisfies CompileVerboseMode { string => "ast"; }
"verbose mode: code"
shared object code satisfies CompileVerboseMode { string => "code"; }
"verbose mode: cmrloader"
shared object cmrloader satisfies CompileVerboseMode { string => "cmrloader"; }
"verbose mode: benchmark"
shared object benchmark satisfies CompileVerboseMode { string => "benchmark"; }

"Verbose modes for jvm backend execution"
shared interface RunVerboseMode of cmr {}
"verbose mode: cmr"
shared object cmr satisfies RunVerboseMode { string => "cmr"; }
