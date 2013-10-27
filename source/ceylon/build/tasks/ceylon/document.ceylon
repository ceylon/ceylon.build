import ceylon.build.task { Task, Context }

"Documents a Ceylon module using `ceylon doc` command line."
shared Task document(
        doc("list of modules to document")
        String|{String+}  modules,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = "",
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--src=<dirs>`)")
        {String*} sourceDirectories = [],
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String|{String*} repositories = [],
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Specifies the folder to use for caching downloaded modules.
             (default: '~/.ceylon/cache')
             (corresponding command line parameter: `--cacherep=<url>`)")
        String? cacheRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("""The URL of a module repository containing documentation for external dependencies.

               Parameter url must be one of supported protocols (http://, https:// or file://).
               Parameter url can be prefixed with module name pattern, separated by a '=' character,
               determine for which external modules will be use.

               Examples:

               --link https://modules.ceylon-lang.org/
               --link ceylon.math=https://modules.ceylon-lang.org/
             
                (corresponding command line parameter: `--link=<url>`)""")
        String? link = null,
        doc("Includes documentation for package-private declarations.
             (corresponding command line parameter: `--non-shared`)")
        Boolean includeNonShared = false,
        doc("Includes source code in the generated documentation.
             (corresponding command line parameter: `--source-code`)")
        Boolean includeSourceCode = false,
        doc("Do not print warnings about broken links.
             (corresponding command line parameter: `--ignore-broken-link`)")
        Boolean ignoreBrokenLink = false,
        doc("Do not print warnings about missing documentation.
             (corresponding command line parameter: `--ignore-missing-doc`)")
        Boolean ignoreMissingDoc = false,
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable,
        doc("Specifies the current working directory for this tool.
             (default: the directory where the tool is run from)
             (corresponding command line parameter: `--cwd=<dir>`)")
        String? currentWorkingDirectory = null
) {
    return function(Context context) {
        value command = buildDocCommand {
            ceylon;
            currentWorkingDirectory;
            multipleStringsIterable(modules);
            encoding;
            sourceDirectories;
            outputRepository;
            stringIterable(repositories);
            systemRepository;
            cacheRepository;
            user;
            password;
            offline;
            link;
            includeNonShared;
            includeSourceCode;
            ignoreBrokenLink;
            ignoreMissingDoc;
            context.arguments;
        };
        return execute(context.writer, "documenting", command);
    };
}