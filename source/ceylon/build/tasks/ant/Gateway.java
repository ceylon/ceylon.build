package ceylon.build.tasks.ant;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;

// Only way to obtain classes within sub-package sealed, to ensure all is done by the correct class loader.
public class Gateway {
    
    private static final String PACKAGE_PREFIX = "ceylon.build.tasks.ant.sealed.";
    
    private GatewayClassLoader gatewayClassLoader;
    
    Gateway() {
        try {
            gatewayClassLoader = new GatewayClassLoader();
            gatewayClassLoader.loadModuleClasses("ceylon.build.tasks.ant", "1.1.0");
            gatewayClassLoader.loadModuleClasses("org.apache.ant.ant", "1.9.4");
        } catch (Exception e) {
            String message = "Cannot create Ant project.";
            throw new AntGatewayException(new ceylon.language.String(message), e);
        }
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
        } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException | ClassNotFoundException | InstantiationException e) {
            String message = "Cannot instantiate " + PACKAGE_PREFIX + className;
            throw new AntGatewayException(new ceylon.language.String(message), e);
        } catch (Exception e) {
            String message = "Exception in underlying Ant wrapper: " + e.getMessage();
            throw new AntException(new ceylon.language.String(message), e);
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
                        throw new AntGatewayException(new ceylon.language.String(message), null);
                    }
                    foundMethod = method;
                }
            }
            if (foundMethod == null) {
                String message = "Cannot invoke method " + methodName + " of " + sealedClass;
                throw new AntGatewayException(new ceylon.language.String(message), null);
            }
            Object result = foundMethod.invoke(object, parameters);
            return result;
        } catch (SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
            String message = "Cannot invoke method " + methodName + " of " + sealedClass;
            throw new AntGatewayException(new ceylon.language.String(message), e);
        } catch (Exception e) {
            String message = "Exception in underlying Ant wrapper: " + e.getMessage();
            throw new AntException(new ceylon.language.String(message), e);
        }
    }
    
    void loadModuleClasses(String moduleName, String moduleVersion) {
        gatewayClassLoader.loadModuleClasses(moduleName, moduleVersion);
    }
    
    void loadUrlClasses(String urlString) {
        try {
            URL url = new URL(urlString);
            gatewayClassLoader.loadUrlClasses(url);
        } catch (MalformedURLException e) {
            throw new RuntimeException("Cannot load URL " + urlString, e);
        }
    }
    
}
