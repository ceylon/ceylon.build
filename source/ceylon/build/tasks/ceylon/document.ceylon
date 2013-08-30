import ceylon.build.task { TaskDefinition, Context }

"Documents a Ceylon module using `ceylon doc` command line."
shared TaskDefinition document(
        doc("name of module to document")
        String moduleName,
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
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
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
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildDocCommand {
            ceylon;
            moduleName;
            encoding;
            sourceDirectories;
            outputModuleRepository;
            dependenciesRepository;
            systemRepository;
            user;
            password;
            offline;
            link;
            includeNonShared;
            includeSourceCode;
            context.arguments;
        };
        return execute(context.writer, "documenting", command);
    };
}