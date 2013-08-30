
doc("All verbose modes for jvm backend compilation / execution")
shared interface AllVerboseModes {}
doc("All verbose modes")
shared object all satisfies AllVerboseModes {}

doc("Verbose modes for jvm backend compilation")
shared interface CompileVerboseMode of loader | ast | code | cmrloader | benchmark {}

doc("verbose mode: loader")
shared object loader satisfies CompileVerboseMode { string => "loader"; }
doc("verbose mode: ast")
shared object ast satisfies CompileVerboseMode { string => "ast"; }
doc("verbose mode: code")
shared object code satisfies CompileVerboseMode { string => "code"; }
doc("verbose mode: cmrloader")
shared object cmrloader satisfies CompileVerboseMode { string => "cmrloader"; }
doc("verbose mode: benchmark")
shared object benchmark satisfies CompileVerboseMode { string => "benchmark"; }

doc("Verbose modes for jvm backend execution")
shared interface RunVerboseMode of cmr {}
doc("verbose mode: cmr")
shared object cmr satisfies RunVerboseMode { string => "cmr"; }
