package ceylon.build.tasks.ant.internal;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Vector;

import org.jboss.modules.Module;
import org.jboss.modules.ModuleClassLoader;
import org.jboss.modules.ModuleIdentifier;
import org.jboss.modules.ModuleLoadException;

class MultiModuleClassLoader extends ClassLoader {
    
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
    
    private ClassLoaderTuple parentClassLoaderTuple;
    private Vector<ClassLoaderTuple> classLoaderTuples = new Vector<>();
    
    public MultiModuleClassLoader(ClassLoader parentClassloader) {
        super(null);
        parentClassLoaderTuple = new ClassLoaderTuple("*parent*", parentClassloader);
        classLoaderTuples.add(parentClassLoaderTuple);
    }
    
    public void addModule(String moduleName, String moduleVersion) throws ModuleLoadException, ClassNotFoundException {
        ModuleIdentifier moduleIdentifier = ModuleIdentifier.create(moduleName, moduleVersion);
        Module jBossModule = Module.getCallerModuleLoader().loadModule(moduleIdentifier);
        ModuleClassLoader moduleClassLoader = jBossModule.getClassLoader();
        String name = moduleName + "/" + moduleVersion;
        ClassLoaderTuple classLoaderTuple = new ClassLoaderTuple(name, moduleClassLoader);
        classLoaderTuples.add(classLoaderTuple);
    }
    
    @Override
    public URL getResource(String resourceName) {
        log("MultiModuleClassLoader getResource(): " + resourceName);
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
        log("MultiModuleClassLoader getResources(): " + resourceName);
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
        log("MultiModuleClassLoader getResourceAsStream(): " + resourceName);
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
    
    @Override
    public Class<?> loadClass(String className) throws ClassNotFoundException {
        log("MultiModuleClassLoader loadClass(): " + className);
        try {
            ClassLoader classLoader = parentClassLoaderTuple.classLoader;
            Class<?> loadClass = classLoader.loadClass(className);
            log("Found in parent classloader.");
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
    
    private void log(String string) {
        // System.out.println(string);
    }
    
}
