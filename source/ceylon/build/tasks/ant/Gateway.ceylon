import java.lang {
    ObjectArray
}
import java.lang.reflect {
    InvocationTargetException
}
import java.net {
    MalformedURLException,
    URL
}

import org.jboss.modules {
    ModuleLoadException
}

class Gateway() {
    
    String packagePrefix = "ceylon.build.tasks.ant.sealed.";
    String sealedAntBuildExceptionName = "ceylon.build.tasks.ant.sealed.SealedAntBuildException";
    String sealedAntUsageExceptionName = "ceylon.build.tasks.ant.sealed.SealedAntUsageException";
    String sealedAntBackendExceptionName = "ceylon.build.tasks.ant.sealed.SealedAntBackendException";
    
    GatewayClassLoader gatewayClassLoader = GatewayClassLoader();
    GatewayCaller gatewayCaller = GatewayCaller(gatewayClassLoader);
    
    shared void loadModuleClasses(String moduleName, String moduleVersion) {
        try {
            gatewayClassLoader.loadModuleClasses(moduleName, moduleVersion);
        } catch (ModuleLoadException e) {
            String message = "Cannot load module: ``moduleName``/``moduleVersion``";
            throw AntLibraryException(message, e);
        }
    }
    
    shared void loadUrlClasses(String urlString) {
        try {
            URL url = URL(urlString);
            gatewayClassLoader.loadUrlClasses(url);
        } catch (MalformedURLException e) {
            String message = "Cannot load URL ``urlString``";
            throw AntLibraryException(message, e);
        }
    }
    
    loadModuleClasses("ceylon.build.tasks.ant", "1.1.0");
    loadModuleClasses("org.apache.ant.ant", "1.9.4");
    
    AntException buildAntException(Exception exception) {
        switch (exception)
        case (is AntWrapperJavaException) {
            String message = exception.message;
            return AntWrapperException(message, exception);
        }
        case (is InvocationTargetException) {
            Throwable? throwable = exception.cause;
            if (exists throwable) {
                String throwableClassName = className(throwable);
                print("ClassName: ``throwableClassName``");
                if (sealedAntBuildExceptionName == throwableClassName) {
                    return AntBuildException(throwable.message, throwable);
                } else if (sealedAntUsageExceptionName == throwableClassName) {
                    return AntUsageException(throwable.message, throwable);
                } else if (sealedAntBackendExceptionName == throwableClassName) {
                    return AntBackendException(throwable.message, throwable);
                } else {
                    String message = "Exception in underlying Ant backend: ``throwable.message``";
                    return AntBackendException(message, throwable);
                }
            }
            return AntBackendException(exception.string, exception);
        }
        else {
            return AntWrapperException(exception.string, exception);
        }
    }
    
    shared Object instatiate(String shortClassName, Object* parameters) {
        try {
            ObjectArray<Object> parameterArray = ObjectArray<Object>(parameters.size);
            for (index->parameter in parameters.indexed) {
                parameterArray.set(index, parameter);
            }
            return gatewayCaller.instatiate(packagePrefix + shortClassName, parameterArray);
        } catch (Exception exception) {
            throw buildAntException(exception);
        }
    }
    
    shared Anything invoke(Object objectReference, String methodName, Object* parameters) {
        try {
            ObjectArray<Object> parameterArray = ObjectArray<Object>(parameters.size);
            for (index->parameter in parameters.indexed) {
                parameterArray.set(index, parameter);
            }
            return gatewayCaller.invoke(objectReference, methodName, parameterArray);
        } catch (Exception exception) {
            throw buildAntException(exception);
        }
    }
    
}