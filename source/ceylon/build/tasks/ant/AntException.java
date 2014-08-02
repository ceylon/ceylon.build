package ceylon.build.tasks.ant;

/**
 * Base class for Ant exceptions.
 */
public abstract class AntException extends ceylon.language.Exception {
    
    private static final long serialVersionUID = 913552923474200198L;
    
    AntException(ceylon.language.String message, Throwable cause) {
        super(message, cause);
    }
    
}
