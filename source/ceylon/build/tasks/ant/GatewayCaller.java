package ceylon.build.tasks.ant;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

// Only way to obtain and call classes within sub-package sealed, to ensure all is done by the correct class loader.
class GatewayCaller {
    
    private GatewayClassLoader gatewayClassLoader;
    
    GatewayCaller(GatewayClassLoader gatewayClassLoader) {
        this.gatewayClassLoader = gatewayClassLoader;
    }
    
    // cannot handle null value in parameters
    private Class<?>[] buildParameterTypes(Object[] parameters)
    throws AntWrapperJavaException {
        Class<?>[] parameterTypes = new Class<?>[parameters.length];
        for (int parametersIndex = 0; parametersIndex < parameters.length; parametersIndex++) {
            Object parameter = parameters[parametersIndex];
            if (parameter != null) {
                parameterTypes[parametersIndex] = parameter.getClass();
            } else {
                String message = "Cannot handle null in parameters.";
                throw new AntWrapperJavaException(message, null);
            }
        }
        return parameterTypes;
    }
    
    Object instatiate(String completeClassName, Object[] parameters)
    throws AntWrapperJavaException, InvocationTargetException {
        Class<?>[] parameterTypes = buildParameterTypes(parameters);
        try {
            Class<?> sealedClass = gatewayClassLoader.loadClass(completeClassName);
            Constructor<?> constructor = sealedClass.getConstructor(parameterTypes);
            Object result = constructor.newInstance(parameters);
            return result;
        } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | ClassNotFoundException | InstantiationException e) {
            String message = "Cannot instantiate " + completeClassName;
            throw new AntWrapperJavaException(message, e);
        }
    }
    
    Object invoke(Object object, String methodName, Object[] parameters)
    throws AntWrapperJavaException, InvocationTargetException {
        Class<?> sealedClass = object.getClass();
        try {
            Method[] methods = sealedClass.getMethods();
            Method foundMethod = null;
            for (Method method : methods) {
                if (method.getName().equals(methodName)) {
                    if (foundMethod != null) {
                        String message = "Cannot handle overloaded methods " + methodName + " of " + sealedClass;
                        throw new AntWrapperJavaException(message, null);
                    }
                    foundMethod = method;
                }
            }
            if (foundMethod == null) {
                String message = "Cannot invoke method " + methodName + " of " + sealedClass;
                throw new AntWrapperJavaException(message, null);
            }
            Object result = foundMethod.invoke(object, parameters);
            return result;
        } catch (SecurityException | IllegalAccessException | IllegalArgumentException e) {
            String message = "Cannot invoke method " + methodName + " of " + sealedClass;
            throw new AntWrapperJavaException(message, e);
        }
    }
    
}
