package ceylon.build.tasks.ant;

/**
 * Indicates an error in the Ant wrapper.
 */
public class AntWrapperException extends AntException {
    
    private static final long serialVersionUID = 913552923474200198L;
    
    AntWrapperException(ceylon.language.String message, Throwable cause) {
        super(message, cause);
    }
    
}
