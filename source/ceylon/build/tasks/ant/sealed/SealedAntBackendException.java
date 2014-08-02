package ceylon.build.tasks.ant.sealed;

public class SealedAntBackendException extends RuntimeException {
    
    private static final long serialVersionUID = 3012997409188737246L;
    
    SealedAntBackendException(String message) {
        super(message);
    }
    
    SealedAntBackendException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
