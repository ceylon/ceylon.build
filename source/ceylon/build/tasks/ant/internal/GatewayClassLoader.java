package ceylon.build.tasks.ant.internal;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Vector;

import org.jboss.modules.Module;
import org.jboss.modules.ModuleClassLoader;
import org.jboss.modules.ModuleIdentifier;
import org.jboss.modules.ModuleLoadException;

class GatewayClassLoader extends ClassLoader {
    
    private static class ClassLoaderTuple {
        String name;
        ClassLoader classLoader;
        ClassLoaderTuple(String name, ClassLoader classLoader) {
            this.name = name;
            this.classLoader = classLoader;
        }
        public String toString() {
            return name;
        }
    }
    
    private Vector<ClassLoaderTuple> classLoaderTuples = new Vector<>();
    private HashMap<String, Class<?>> loadedClassesMap = new HashMap<String, Class<?>>();
    
    GatewayClassLoader() {
        super(null);
    }
    
    private void log(String string) {
        // System.out.println(string);
    }
    
    void loadModuleClasses(String moduleName, String moduleVersion) throws RuntimeException {
        try {
            ModuleIdentifier moduleIdentifier = ModuleIdentifier.create(moduleName, moduleVersion);
            Module jBossModule = Module.getCallerModuleLoader().loadModule(moduleIdentifier);
            ModuleClassLoader moduleClassLoader = jBossModule.getClassLoader();
            String name = moduleName + "/" + moduleVersion;
            ClassLoaderTuple classLoaderTuple = new ClassLoaderTuple(name, moduleClassLoader);
            classLoaderTuples.add(classLoaderTuple);
        } catch (ModuleLoadException e) {
            throw new RuntimeException("Cannot load module: " + moduleName + "/" + moduleVersion, e);
        }
    }
    
    void loadUrlClasses(URL url) throws RuntimeException {
        URLClassLoader urlClassLoader = new URLClassLoader(new URL[] { url } );
        String name = url.toString();
        ClassLoaderTuple classLoaderTuple = new ClassLoaderTuple(name, urlClassLoader);
        classLoaderTuples.add(classLoaderTuple);
    }
    
    @Override
    public URL getResource(String resourceName) {
        log("GatewayClassLoader getResource(): " + resourceName);
        URL result = null;
        for (ClassLoaderTuple classLoaderTuple : classLoaderTuples) {
            ClassLoader classLoader = classLoaderTuple.classLoader; 
            result = classLoader.getResource(resourceName);
            if (result != null) {
                break;
            }
        }
        return result;
    }
    
    @Override
    public Enumeration<URL> getResources(String resourceName) throws IOException {
        log("GatewayClassLoader getResources(): " + resourceName);
        Vector<URL> result = new Vector<URL>(); 
        for (ClassLoaderTuple classLoaderTuple : classLoaderTuples) {
            ClassLoader classLoader = classLoaderTuple.classLoader; 
            try {
                Enumeration<URL> resources = classLoader.getResources(resourceName);
                ArrayList<URL> list = Collections.list(resources);
                result.addAll(list);
            } catch (IOException ioException) {
                // continue
            }
        }
        return result.elements();
    }
    
    @Override
    public InputStream getResourceAsStream(String resourceName) {
        log("GatewayClassLoader getResourceAsStream(): " + resourceName);
        InputStream result = null;
        for (ClassLoaderTuple classLoaderTuple : classLoaderTuples) {
            ClassLoader classLoader = classLoaderTuple.classLoader; 
            result = classLoader.getResourceAsStream(resourceName);
            if (result != null) {
                break;
            }
        }
        return result;
    }
    
    private synchronized Class<?> loadClassInternal(String className) throws ClassNotFoundException {
        log("GatewayClassLoader loadClass(): " + className);
        try {
            ClassLoader classLoader = ClassLoader.getSystemClassLoader();
            Class<?> loadClass = classLoader.loadClass(className);
            log("Found in system classloader.");
            return loadClass;
        } catch (ClassNotFoundException classNotFoundException) {
            // continue
        }
        String resourceName = className.replace('.', '/') + ".class";
        for (ClassLoaderTuple classLoaderTuple : classLoaderTuples) {
            ClassLoader classLoader = classLoaderTuple.classLoader; 
            InputStream inputStream = classLoader.getResourceAsStream(resourceName);
            if (inputStream != null) {
                try {
                    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                    int byteRead;
                    while ((byteRead = inputStream.read()) != -1) {
                      buffer.write(byteRead);
                    }
                    buffer.flush();
                    byte[] bytes = buffer.toByteArray();
                    Class<?> result = super.defineClass(className, bytes, 0, bytes.length);
                    super.resolveClass(result);
                    log("Found in module " + classLoaderTuple.name);
                    return result;
                } catch (IOException e) {
                    // continue with next class loader
                }
            }
        }
        throw new ClassNotFoundException("Could not load class " + className + " from modules " + classLoaderTuples);
    }
    
    @Override
    public Class<?> loadClass(String className) throws ClassNotFoundException {
        Class<?> clazz = loadedClassesMap.get(className);
        if (clazz == null) {
            synchronized (loadedClassesMap) {
                clazz = loadClassInternal(className);
                loadedClassesMap.put(className, clazz);
            }
        }
        return clazz;
    }
    
    @Override
    public String toString() {
        boolean alreadyAppended = false;
        StringBuilder result = new StringBuilder("GatewayClassLoader: [ ");
        for (ClassLoaderTuple classLoaderTuple : classLoaderTuples) {
            if (alreadyAppended) {
                result.append(", ");
            }
            ClassLoader classLoader = classLoaderTuple.classLoader;
            result.append(classLoader.toString());
            alreadyAppended = true;
        }
        result.append(" ]");
        return result.toString();
    }
    
}
