import ceylon.build.task { Task, Context }

"Documents a Ceylon module using `ceylon doc` tool."
shared Task document(
        "list of modules to document"
        String|{String+}  modules,
        "encoding used for reading source files
         (default: platform-specific)
         (corresponding command line parameter: `--encoding=<encoding>`)"
        String? encoding = null,
        "Path to source files
         (default: './source')
         (corresponding command line parameter: `--source=<dirs>`)"
        String|{String*} sourceDirectories = [],
        "A directory containing your module documentation
         (default: './doc')
         (corresponding command line parameter: `--doc=<dirs>`)"
        String? documentationDirectory = null,
        "Specifies the output module repository (which must be publishable).
         (default: './modules')
         (corresponding command line parameter: `--out=<url>`)"
        String? outputRepository = null,
        "Specifies a module repository containing dependencies. Can be specified multiple times.
         (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
         (corresponding command line parameter: `--rep=<url>`)"
        String|{String*} repositories = [],
        "Specifies the system repository containing essential modules.
         (default: '$CEYLON_HOME/repo')
         (corresponding command line parameter: `--sysrep=<url>`)"
        String? systemRepository = null,
        "Specifies the folder to use for caching downloaded modules.
         (default: '~/.ceylon/cache')
         (corresponding command line parameter: `--cacherep=<url>`)"
        String? cacheRepository = null,
        "Sets the user name for use with an authenticated output repository
         (corresponding command line parameter: `--user=<name>`)"
        String? user = null,
        "Sets the password for use with an authenticated output repository
         (corresponding command line parameter: `--pass=<secret>`)"
        String? password = null,
        "Enables offline mode that will prevent the module loader from connecting to remote repositories.
         (corresponding command line parameter: `--offline`)"
        Boolean offline = false,
        "The URL of a module repository containing documentation for external dependencies.

         Parameter url must be one of supported protocols (http://, https:// or file://).
         Parameter url can be prefixed with module name pattern, separated by a '=' character,
         determine for which external modules will be use.

         Examples:

         - --link https://modules.ceylon-lang.org/
         - --link ceylon.math=https://modules.ceylon-lang.org/
             
         (corresponding command line parameter: `--link=<url>`)"
        String? link = null,
        "Includes documentation for package-private declarations.
         (corresponding command line parameter: `--non-shared`)"
        Boolean includeNonShared = false,
        "Includes source code in the generated documentation.
         (corresponding command line parameter: `--source-code`)"
        Boolean includeSourceCode = false,
        "Do not print warnings about broken links.
         (corresponding command line parameter: `--ignore-broken-link`)"
        Boolean ignoreBrokenLink = false,
        "Do not print warnings about missing documentation.
         (corresponding command line parameter: `--ignore-missing-doc`)"
        Boolean ignoreMissingDoc = false,
        "Do not print warnings about missing throws annotation.
         (corresponding command line parameter: `--ignore-missing-throws`)"
        Boolean ignoreMissingThrows = false,
        "Sets the header text to be placed at the top of each page.
         (corresponding command line parameter: `--header=<header>`)"
        String? header = null,
        "Sets the footer text to be placed at the bottom of each page.
         (corresponding command line parameter: `--footer=<footer>`)"
        String? footer = null,
        "Set system properties
         (corresponding command line parameter: `--define=<key>=<value>`, `-D <key>=<value>`)"
        {<String->String>*} systemProperties = [],
        "Produce verbose output.
         (corresponding command line parameter: `--verbose=<flags>`)"
        {DocVerboseMode*}|AllVerboseModes verboseModes = [],
        "Ceylon executable that will be used or null to use current ceylon tool"
        String? ceylon = null,
        "Specifies the current working directory for this tool.
         (default: the directory where the tool is run from)
         (corresponding command line parameter: `--cwd=<dir>`)"
        String? currentWorkingDirectory = null
) {
    return function(Context context) {
        value command = docCommand {
            currentWorkingDirectory = currentWorkingDirectory;
            modules = multipleStringsIterable(modules);
            encoding = encoding;
            sourceDirectories = stringIterable(sourceDirectories);
            documentationDirectory = documentationDirectory;
            outputRepository = outputRepository;
            repositories = stringIterable(repositories);
            systemRepository = systemRepository;
            cacheRepository = cacheRepository;
            user = user;
            password = password;
            offline = offline;
            link = link;
            includeNonShared = includeNonShared;
            includeSourceCode = includeSourceCode;
            ignoreBrokenLink = ignoreBrokenLink;
            ignoreMissingDoc = ignoreMissingDoc;
            ignoreMissingThrows = ignoreMissingThrows;
            header = header;
            footer = footer;
            systemProperties = systemProperties;
            verboseModes = verboseModes;
            arguments = context.arguments;
        };
        return execute(context.writer, "documenting", ceylon, command);
    };
}