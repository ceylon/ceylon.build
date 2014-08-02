package ceylon.build.tasks.ant.sealed;

public class SealedAntUsageException extends RuntimeException {
    
    private static final long serialVersionUID = 8850924032517795389L;
    
    SealedAntUsageException(String message) {
        super(message);
    }
    
    SealedAntUsageException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
