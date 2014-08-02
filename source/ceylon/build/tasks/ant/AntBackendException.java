package ceylon.build.tasks.ant;

/**
 * Indicates an error in the wrapper, in Ant itself, or in the implementing Ant type/task.
 * Or might be actually a usage error but it's not handled correctly by the wrapper.
 */
public class AntBackendException extends AntException {
    
    private static final long serialVersionUID = -1403288255722732400L;
    
    AntBackendException(ceylon.language.String message, Throwable cause) {
        super(message, cause);
    }
    
}
