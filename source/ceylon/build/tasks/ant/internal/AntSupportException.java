package ceylon.build.tasks.ant.internal;

public class AntSupportException extends RuntimeException {
    
    private static final long serialVersionUID = 1L;
    
    public AntSupportException(String message) {
        super(message);
    }
    
    public AntSupportException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
