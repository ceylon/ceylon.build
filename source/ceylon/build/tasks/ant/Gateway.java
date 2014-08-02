package ceylon.build.tasks.ant;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;

import org.jboss.modules.ModuleLoadException;

// Only way to obtain classes within sub-package sealed, to ensure all is done by the correct class loader.
public class Gateway {
    
    private static final String PACKAGE_PREFIX = "ceylon.build.tasks.ant.sealed.";
    private static final String BUILD_EXCEPTION_NAME = org.apache.tools.ant.BuildException.class.getName();
    // It's okay to access the sealed package here, because only the class name is used.
    private static final String SEALED_ANT_USAGE_EXCEPTION_NAME = ceylon.build.tasks.ant.sealed.SealedAntUsageException.class.getName();
    private static final String SEALED_ANT_BACKEND_EXCEPTION_NAME = ceylon.build.tasks.ant.sealed.SealedAntBackendException.class.getName();
    
    private GatewayClassLoader gatewayClassLoader;
    
    Gateway() {
        gatewayClassLoader = new GatewayClassLoader();
        loadModuleClasses("ceylon.build.tasks.ant", "1.1.0");
        loadModuleClasses("org.apache.ant.ant", "1.9.4");
    }
    
    // cannot handle null value in parameters
    private Class<?>[] buildParameterTypes(Object... parameters) {
        Class<?>[] parameterTypes = new Class<?>[parameters.length];
        for (int parametersIndex = 0; parametersIndex < parameters.length; parametersIndex++) {
            Object parameter = parameters[parametersIndex];
            if (parameter != null) {
                parameterTypes[parametersIndex] = parameter.getClass();
            }
        }
        return parameterTypes;
    }
    
    Object instatiate(String className, Object... parameters) {
        Class<?>[] parameterTypes = buildParameterTypes(parameters);
        try {
            Class<?> sealedClass = gatewayClassLoader.loadClass(PACKAGE_PREFIX + className);
            Constructor<?> constructor = sealedClass.getConstructor(parameterTypes);
            Object result = constructor.newInstance(parameters);
            return result;
        } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | ClassNotFoundException | InstantiationException e) {
            String message = "Cannot instantiate " + PACKAGE_PREFIX + className;
            throw new AntWrapperException(new ceylon.language.String(message), e);
        } catch (InvocationTargetException invocationTargetException) {
            AntException antException = buildAntException(invocationTargetException);
            throw antException;
        }
    }
    
    Object invoke(Object object, String methodName, Object... parameters) {
        Class<?> sealedClass = object.getClass();
        try {
            Method[] methods = sealedClass.getMethods();
            Method foundMethod = null;
            for (Method method : methods) {
                if (method.getName().equals(methodName)) {
                    if (foundMethod != null) {
                        String message = "Cannot handle overloaded methods " + methodName + " of " + sealedClass;
                        throw new AntWrapperException(new ceylon.language.String(message), null);
                    }
                    foundMethod = method;
                }
            }
            if (foundMethod == null) {
                String message = "Cannot invoke method " + methodName + " of " + sealedClass;
                throw new AntWrapperException(new ceylon.language.String(message), null);
            }
            Object result = foundMethod.invoke(object, parameters);
            return result;
        } catch (SecurityException | IllegalAccessException | IllegalArgumentException e) {
            String message = "Cannot invoke method " + methodName + " of " + sealedClass;
            throw new AntWrapperException(new ceylon.language.String(message), e);
        } catch (InvocationTargetException invocationTargetException) {
            AntException antException = buildAntException(invocationTargetException);
            throw antException;
        }
    }
    
    private AntException buildAntException(InvocationTargetException invocationTargetException) {
        Throwable throwable= invocationTargetException.getCause();
        String className = throwable.getClass().getName();
        if (className.equals(BUILD_EXCEPTION_NAME)) {
            String message = throwable.getMessage();
            return new AntBuildException(new ceylon.language.String(message), throwable);
        } else if (className.equals(SEALED_ANT_USAGE_EXCEPTION_NAME)) {
            String message = throwable.getMessage();
            return new AntUsageException(new ceylon.language.String(message), throwable);
        } else if (className.equals(SEALED_ANT_BACKEND_EXCEPTION_NAME)) {
            String message = throwable.getMessage();
            return new AntBackendException(new ceylon.language.String(message), throwable);
        } else {
            String message = "Exception in underlying Ant wrapper: " + throwable.getMessage();
            return new AntBackendException(new ceylon.language.String(message), throwable);
        }
    }
    
    void loadModuleClasses(String moduleName, String moduleVersion) {
        try {
            gatewayClassLoader.loadModuleClasses(moduleName, moduleVersion);
        } catch (ModuleLoadException e) {
            String message = "Cannot load module: " + moduleName + "/" + moduleVersion;
            throw new AntLibraryException(new ceylon.language.String(message), e);
        }
    }
    
    void loadUrlClasses(String urlString) {
        try {
            URL url = new URL(urlString);
            gatewayClassLoader.loadUrlClasses(url);
        } catch (MalformedURLException e) {
            String message = "Cannot load URL " + urlString;
            throw new AntLibraryException(new ceylon.language.String(message), e);
        }
    }
    
}
