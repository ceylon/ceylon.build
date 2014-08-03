package ceylon.build.tasks.ant;

/**
 * Indicates an error in the Ant wrapper.
 * Gets rewrapped in a Ceylon Exception.
 * This is because Java cannot see Ceylon classes in the same module.
 */
public class AntWrapperJavaException extends Exception {
    
    private static final long serialVersionUID = 913552923474200198L;
    
    AntWrapperJavaException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
