package ceylon.build.tasks.ant.internal;

public class AntException extends RuntimeException {
    
    private static final long serialVersionUID = 913552923474200198L;
    
    // Package private constructor to ensure correct class loader.
    AntException(String message) {
        super(message);
    }
    
    // Package private constructor to ensure correct class loader.
    AntException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
