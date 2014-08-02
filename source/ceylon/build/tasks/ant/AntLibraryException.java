package ceylon.build.tasks.ant;

/**
 * Class loader could not find the requested library.
 */
public class AntLibraryException extends AntException {
    
    private static final long serialVersionUID = 8600028090693132266L;
    
    AntLibraryException(ceylon.language.String message, Throwable cause) {
        super(message, cause);
    }
    
}
