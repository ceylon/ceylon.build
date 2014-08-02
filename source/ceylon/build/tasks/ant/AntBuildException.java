package ceylon.build.tasks.ant;

/**
 * Whilst initialising or executing an Ant type/task a BuildException occured.
 * @see org.apache.tools.ant.BuildException
 */
public class AntBuildException extends AntException {
    
    private static final long serialVersionUID = 1214356499575316061L;
    
    AntBuildException(ceylon.language.String message, Throwable cause) {
        super(message, cause);
    }
    
}
