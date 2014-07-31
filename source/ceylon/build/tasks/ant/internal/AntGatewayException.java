package ceylon.build.tasks.ant.internal;

public class AntGatewayException extends RuntimeException {
    
    private static final long serialVersionUID = 913552923474200198L;
    
    // Package private constructor to ensure correct class loader.
    AntGatewayException(String message) {
        super(message);
    }
    
    // Package private constructor to ensure correct class loader.
    AntGatewayException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
