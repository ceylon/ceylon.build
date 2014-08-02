package ceylon.build.tasks.ant;

/**
 * Indicates an error in the wrapper, in Ant itself, or in the implementing Ant type/task.
 */
public class AntUsageException extends AntException {
    
    private static final long serialVersionUID = 1034531153652713304L;
    
    AntUsageException(ceylon.language.String message, Throwable cause) {
        super(message, cause);
    }
    
}
