package ceylon.build.tasks.ant.sealed;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLStreamHandler;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Vector;

import org.apache.tools.ant.AntTypeDefinition;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildLogger;
import org.apache.tools.ant.ComponentHelper;
import org.apache.tools.ant.DefaultLogger;
import org.apache.tools.ant.IntrospectionHelper;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;
import org.apache.tools.ant.ProjectHelperRepository;
import org.apache.tools.ant.PropertyHelper;
import org.apache.tools.ant.TypeAdapter;
import org.apache.tools.ant.UnknownElement;
import org.apache.tools.ant.helper.ProjectHelper2;
import org.apache.tools.ant.types.resources.StringResource;

public class SealedProject {
    
    private static class BytesURLStreamHandler extends URLStreamHandler {
        public URLConnection openConnection(URL url) {
            return new BytesURLConnection(url);
        }
    }
    
    private static class BytesURLConnection extends URLConnection {
        protected byte[] content;
        public BytesURLConnection(URL url) {
            super(url);
            String string = url.toString().substring("utf8bytes:".length());
            try {
                this.content = string.getBytes("UTF-8");
            } catch (UnsupportedEncodingException e) {
                throw new SealedAntBackendException("UTF-8 should exist", e);
            }
        }
        public void connect() {
        }
        public InputStream getInputStream() {
            return new ByteArrayInputStream(content);
        }
    }
    
    private final static String MINIMAL_BUILD_FILE = "<project default=\"main\" basedir=\".\"><target name=\"main\"><echo message=\"Hello world!\"/></target></project>";
    
    private Project project;
    
    private static Project createProject() {
        try {
            Project project = new Project();
            // set ClassLoader
            project.setCoreLoader(project.getClass().getClassLoader());
            // first simulate project
            project.fireBuildStarted();
            // do what ProjectHelper.configureProject(project, new File("build.xml")); does with the minimal build file
            StringResource stringResource = new StringResource(project, MINIMAL_BUILD_FILE);
            URL url = new URL(null, "utf8bytes:" + MINIMAL_BUILD_FILE, new BytesURLStreamHandler());
            ProjectHelper projectHelper = ProjectHelperRepository.getInstance().getProjectHelperForBuildFile(stringResource);
            project.addReference(ProjectHelper.PROJECTHELPER_REFERENCE, projectHelper);
            projectHelper.parse(project, url);
            // execute main with echo task, so that tasks get known to Ant
            Vector<String> targets = new Vector<>();
            targets.add("main");
            project.executeTargets(targets);
            // set logger
            project.addBuildListener(createLogger());
            return project;
        } catch (MalformedURLException e) {
            throw new RuntimeException("Cannot handle internal URL.", e);
        }
    }
    
    private static BuildLogger createLogger() {
        BuildLogger logger = new DefaultLogger();
        logger.setMessageOutputLevel(Project.MSG_INFO);
        logger.setOutputPrintStream(System.out);
        logger.setErrorPrintStream(System.err);
        return logger;
    }
    
    public SealedProject() {
        this.project = createProject();
    }
    
    Project getProject() {
        return project;
    }
    
    SealedAnt createSealedAnt(String antName) {
        return new SealedAnt(antName, this);
    }
    
    public Map<String, String> getAllProperties() {
        Map<String, String> allProperties = new HashMap<String, String>();
        Hashtable<String, Object> properties = project.getProperties();
        for (String propertyName : properties.keySet()) {
            Object propertyObject = properties.get(propertyName);
            if (propertyObject != null) {
                String propertyValue = propertyObject.toString();
                allProperties.put(propertyName, propertyValue);
            }
        }
        return allProperties;
    }
    
    public String getProperty(String propertyName) {
        return project.getProperty(propertyName);
    }
    
    public void setProperty(String propertyName, String propertyValue) {
        project.setProperty(propertyName, propertyValue);
    }
    
    @SuppressWarnings("unchecked")
    public void unsetProperty(String propertyName) {
        try {
            PropertyHelper propertyHelper = PropertyHelper.getPropertyHelper(project);
            Hashtable<String, Object> properties = (Hashtable<String, Object>) getValue(propertyHelper, "properties");
            properties.remove(propertyName);
            Hashtable<String, Object> userProperties = (Hashtable<String, Object>) getValue(propertyHelper, "userProperties");
            userProperties.remove(propertyName);
            Hashtable<String, Object> inheritedProperties = (Hashtable<String, Object>) getValue(propertyHelper, "inheritedProperties");
            inheritedProperties.remove(propertyName);
        } catch (Exception e) {
            throw new SealedAntBackendException("Cannot access internal fields to unset property.", e);
        }
    }
    
    private Object getValue(Object instance, String fieldName)
    throws NoSuchFieldException, IllegalArgumentException, IllegalAccessException {
        Field field = getField(instance.getClass(), fieldName);
        field.setAccessible(true);
        return field.get(instance);
    }
    
    private Field getField(Class<?> thisClass, String fieldName)
    throws NoSuchFieldException {
        if (thisClass == null) {
           throw new NoSuchFieldException("Invalid field: " + fieldName);
        }
        try {
           return thisClass.getDeclaredField(fieldName);
        } catch (NoSuchFieldException e) {
           return getField(thisClass.getSuperclass(), fieldName);
        }
     }
    
    public String getBaseDirectory() {
        return project.getBaseDir().toString();
    }
    
    public void setBaseDirectory(String newBaseDirectory) {
        project.setBaseDir(new File(newBaseDirectory));
    }
    
    public List<SealedAntDefinition> getTopLevelSealedAntDefinitions() {
        List<SealedAntDefinition> topLevelSealedAntDefinitions = new ArrayList<SealedAntDefinition>();
        ComponentHelper componentHelper = ComponentHelper.getComponentHelper(project);
        Hashtable<String, AntTypeDefinition> antTypeTable = componentHelper.getAntTypeTable();
        for (Entry<String, AntTypeDefinition> antTypeEntry : antTypeTable.entrySet()) {
            try {
                String antName = antTypeEntry.getKey().toLowerCase(Locale.ENGLISH);
                AntTypeDefinition antTypeDefinition = componentHelper.getDefinition(antName);
                Object instantiateObject = antTypeDefinition.create(project);
                Object effectiveObject = instantiateObject;
                if (instantiateObject instanceof TypeAdapter) {
                    effectiveObject = ((TypeAdapter) instantiateObject).getProxy();
                }
                @SuppressWarnings("unchecked")
                Class<Object> instantiatedType = (Class<Object>) instantiateObject.getClass();
                @SuppressWarnings("unchecked")
                Class<Object> effectiveType = (Class<Object>) effectiveObject.getClass();
                IntrospectionHelper introspectionHelper = IntrospectionHelper.getHelper(project, effectiveType);
                SealedAntDefinition sealedAntDefinition = new SealedAntDefinition(project, antName, instantiatedType, effectiveType, introspectionHelper, false);
                topLevelSealedAntDefinitions.add(sealedAntDefinition);
            } catch (Exception exception) {
                // continue with next Ant type, most likely couldn't instantiate object
            }
        }
        return topLevelSealedAntDefinitions;
    }
    
    public void executeXml(String xml) {
        ProjectHelper2 projectHelper2 = new ProjectHelper2();
        URL url;
        try {
            url = new URL(null, "utf8bytes:<sequential>" + xml + "</sequential>", new BytesURLStreamHandler());
        } catch (MalformedURLException e) {
            throw new SealedAntBackendException("URL for utf8bytes: should work.", e);
        }
        try {
            UnknownElement unknownElement = projectHelper2.parseUnknownElement(project, url);
            unknownElement.maybeConfigure();
            unknownElement.execute();
        } catch (BuildException buildException) {
            throw new SealedAntBuildException(buildException.getMessage(), buildException);
        }
    }
    
}
