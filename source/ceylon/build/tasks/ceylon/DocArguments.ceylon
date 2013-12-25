"Holds arguments to be passed to ceylon doc tool."
shared class DocArguments(
    modules,
    encoding = null,
    sourceDirectories = [],
    documentationDirectory = null,
    outputRepository = null,
    repositories = [],
    systemRepository = null,
    cacheRepository = null,
    user = null,
    password = null,
    offline = false,
    link = null,
    includeNonShared = false,
    includeSourceCode = false,
    ignoreBrokenLink = false,
    ignoreMissingDoc = false,
    ignoreMissingThrows = false,
    header = null,
    footer = null,
    systemProperties = [],
    verboseModes = [],
    currentWorkingDirectory = null,
    arguments = []) {
    
    "name of modules to doc"
    shared {String+} modules;
    
    "encoding used for reading source files
     (default: platform-specific)
     (corresponding command line parameter: `--encoding=<encoding>`)"
    shared String? encoding;
    
    "Path to source files
     (default: './source')
     (corresponding command line parameter: `--source=<dirs>`)"
    shared {String*} sourceDirectories;
    
    "A directory containing your module documentation
     (default: './doc')
     (corresponding command line parameter: `--doc=<dirs>`)"
    shared String? documentationDirectory;
    
    "Specifies the output module repository (which must be publishable).
     (default: './modules')
     (corresponding command line parameter: `--out=<url>`)"
    shared String? outputRepository;
    
    "Specifies a module repository containing dependencies. Can be specified multiple times.
     (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
     (corresponding command line parameter: `--rep=<url>`)"
    shared {String*} repositories;
    
    "Specifies the system repository containing essential modules.
     (default: '$CEYLON_HOME/repo')
     (corresponding command line parameter: `--sysrep=<url>`)"
    shared String? systemRepository;
    
    "Specifies the folder to use for caching downloaded modules.
     (default: '~/.ceylon/cache')
     (corresponding command line parameter: `--cacherep=<url>`)"
    shared String? cacheRepository;
    
    "Sets the user name for use with an authenticated output repository
     (corresponding command line parameter: `--user=<name>`)"
    shared String? user;
    
    "Sets the password for use with an authenticated output repository
     (corresponding command line parameter: `--pass=<secret>`)"
    shared String? password;
    
    "Enables offline mode that will prevent the module loader from connecting to remote repositories.
     (corresponding command line parameter: `--offline`)"
    shared Boolean offline;
    
    "The URL of a module repository containing documentation for external dependencies.
     
     Parameter url must be one of supported protocols (http://, https:// or file://).
     Parameter url can be prefixed with module name pattern, separated by a '=' character,
     determine for which external modules will be use.
     
     Examples:
     
     - --link https://modules.ceylon-lang.org/
     - --link ceylon.math=https://modules.ceylon-lang.org/
     
     (corresponding command line parameter: `--link=<url>`)"
    shared String? link;
    
    "Includes documentation for package-private declarations.
     (corresponding command line parameter: `--non-shared`)"
    shared Boolean includeNonShared;
    
    "Includes source code in the generated documentation.
     (corresponding command line parameter: `--source-code`)"
    shared Boolean includeSourceCode;
    
    "Do not print warnings about broken links.
     (corresponding command line parameter: `--ignore-broken-link`)"
    shared Boolean ignoreBrokenLink;
    
    "Do not print warnings about missing documentation.
     (corresponding command line parameter: `--ignore-missing-doc`)"
    shared Boolean ignoreMissingDoc;
    
    "Do not print warnings about missing throws annotation.
     (corresponding command line parameter: `--ignore-missing-throws`)"
    shared Boolean ignoreMissingThrows;
    
    "Sets the header text to be placed at the top of each page.
     (corresponding command line parameter: `--header=<header>`)"
    shared String? header;
    
    "Sets the footer text to be placed at the bottom of each page.
     (corresponding command line parameter: `--footer=<footer>`)"
    shared String? footer;
    
    "Set system properties
     (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
    shared {<String->String>*} systemProperties;
    
    "Specifies the current working directory for this tool.
     (default: the directory where the tool is run from)
     (corresponding command line parameter: `--cwd=<dir>`)"
    shared String? currentWorkingDirectory;
    
    "Produce verbose output.
     (corresponding command line parameter: `--verbose=<flags>`)"
    shared {DocVerboseMode*}|AllVerboseModes verboseModes;
    
    "custom arguments to be added to commandline"
    shared {String*} arguments;
}
