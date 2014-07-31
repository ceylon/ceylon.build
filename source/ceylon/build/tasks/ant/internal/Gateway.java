package ceylon.build.tasks.ant.internal;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;

import ceylon.language.Finished;
import ceylon.language.Iterator;

// Only way to obtain classes within sub-package sealed, to ensure all is done by the correct class loader.
public class Gateway {
    
    private static final String PACKAGE_PREFIX = "ceylon.build.tasks.ant.internal.sealed.";
    
    private GatewayClassLoader gatewayClassLoader;
    
    private void createClassLoader(ceylon.language.Iterable<?, ?> moduleDescriptors) {
        gatewayClassLoader = new GatewayClassLoader();
        gatewayClassLoader.loadModuleClasses("ceylon.build.tasks.ant", "1.1.0");
        gatewayClassLoader.loadModuleClasses("org.apache.ant.ant", "1.9.4");
        if (moduleDescriptors != null) {
            Iterator<?> iterator = moduleDescriptors.iterator();
            while (true) {
                Object nextValue = iterator.next();
                if (nextValue instanceof Finished) {
                    break;
                }
                String moduleDescriptor = nextValue.toString();
                String[] moduleDescriptorSplitted = moduleDescriptor.split("/");
                if (moduleDescriptorSplitted.length > 2) {
                    throw new AntGatewayException("Module descriptor has not correct format: " + moduleDescriptor);
                }
                String moduleName = moduleDescriptorSplitted[0];
                String moduleVersion = moduleDescriptorSplitted.length == 1 ? "" : moduleDescriptorSplitted[1];
                gatewayClassLoader.loadModuleClasses(moduleName, moduleVersion);
            }
        }
    }
    
    // Type of moduleDescriptors would possibly be ceylon.language.Iterable<? extends ceylon.language.String, ? extends ceylon.language.Null>
    public Gateway(String baseDirectory, ceylon.language.Iterable<?, ?> moduleDescriptors) {
        try {
            createClassLoader(moduleDescriptors);
        } catch (Exception e) {
            throw new AntGatewayException("Cannot create Ant project.", e);
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
    
    public Object instatiate(String className, Object... parameters) {
        Class<?>[] parameterTypes = buildParameterTypes(parameters);
        try {
            Class<?> sealedClass = gatewayClassLoader.loadClass(PACKAGE_PREFIX + className);
            Constructor<?> constructor = sealedClass.getConstructor(parameterTypes);
            Object result = constructor.newInstance(parameters);
            return result;
        } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException | ClassNotFoundException | InstantiationException e) {
            throw new AntGatewayException("Cannot instantiate " + PACKAGE_PREFIX + className, e);
        } catch (Exception e) {
            throw new AntException("Exception in underlying Ant wrapper: " + e.getMessage(), e);
        }
    }
    
    public Object invoke(Object object, String methodName, Object... parameters) {
        Class<?> sealedClass = object.getClass();
        try {
            Method[] methods = sealedClass.getMethods();
            Method foundMethod = null;
            for (Method method : methods) {
                if (method.getName().equals(methodName)) {
                    if (foundMethod != null) {
                        throw new AntGatewayException("Cannot handle overloaded methods " + methodName + " of " + sealedClass);
                    }
                    foundMethod = method;
                }
            }
            if (foundMethod == null) {
                throw new AntGatewayException("Cannot invoke method " + methodName + " of " + sealedClass);
            }
            Object result = foundMethod.invoke(object, parameters);
            return result;
        } catch (SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
            throw new AntGatewayException("Cannot invoke method " + methodName + " of " + sealedClass, e);
        } catch (Exception e) {
            throw new AntException("Exception in underlying Ant wrapper: " + e.getMessage(), e);
        }
    }
    
    public ProjectSupport createProjectSupport(String baseDirectory) {
        Object sealedProject = this.instatiate("SealedProject", baseDirectory);
        return new ProjectSupport(this, sealedProject);
    }
    
    public void loadModuleClasses(String moduleName, String moduleVersion) {
        gatewayClassLoader.loadModuleClasses(moduleName, moduleVersion);
    }
    
    public void loadUrlClasses(URL url) {
        gatewayClassLoader.loadUrlClasses(url);
    }
    
}
