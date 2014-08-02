package ceylon.build.tasks.ant.sealed;

public class SealedAntException extends RuntimeException {
    
    private static final long serialVersionUID = 1L;
    
    // Package private constructor to ensure correct class loader.
    SealedAntException(String message) {
        super(message);
    }
    
    // Package private constructor to ensure correct class loader.
    SealedAntException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
