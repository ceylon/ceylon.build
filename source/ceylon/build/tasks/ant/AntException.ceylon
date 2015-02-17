"""
   Base class for Ant exceptions.
"""
shared abstract class AntException(String message, Throwable cause) extends Exception (message, cause) {}

"""
   Indicates an error in the wrapper, in Ant itself, or in the implementing Ant type/task.
   Or might be actually a usage error but it's not handled correctly by the wrapper.
"""
shared class AntBackendException(String message, Throwable cause) extends AntException (message, cause) {}

"""
   Whilst initialising or executing an Ant type/task a [[org.apache.tools.ant::BuildException]] occured.
"""
shared class AntBuildException(String message, Throwable cause) extends AntException (message, cause) {}

"""
   Class loader could not find the requested library.
   """
shared class AntLibraryException(String message, Throwable cause) extends AntException (message, cause) {}

"""
   Indicates a wrong usage of Ant.
"""
shared class AntUsageException(String message, Throwable cause) extends AntException (message, cause) {}

"""
   Indicates an error in the Ant wrapper.
"""
shared class AntWrapperException(String message, Throwable cause) extends AntException (message, cause) {}
