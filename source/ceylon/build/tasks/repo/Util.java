package ceylon.build.tasks.repo;

import java.lang.reflect.Field;
import java.util.Arrays;

import org.apache.maven.repository.internal.MavenServiceLocator;
import org.apache.maven.wagon.Wagon;
import org.apache.maven.wagon.providers.http.LightweightHttpWagon;
import org.apache.maven.wagon.providers.http.LightweightHttpWagonAuthenticator;
import org.sonatype.aether.RepositorySystem;
import org.sonatype.aether.connector.wagon.WagonProvider;
import org.sonatype.aether.connector.wagon.WagonRepositoryConnectorFactory;
import org.sonatype.aether.spi.connector.RepositoryConnectorFactory;

public class Util {
	
	public Util() {
		super();
	}
	
    public static RepositorySystem lookupSystem() {
        MavenServiceLocator locator = new MavenServiceLocator();
        locator.addService(RepositoryConnectorFactory.class,WagonRepositoryConnectorFactory.class);
        locator.setServices(WagonProvider.class, new WagonProvider() {
            public Wagon lookup(String roleHint) throws Exception {
                if (Arrays.asList("http", "https").contains(roleHint)) {
                    Wagon wagon = new LightweightHttpWagon();
                    LightweightHttpWagonAuthenticator authenticator = new LightweightHttpWagonAuthenticator();
                    Field field = LightweightHttpWagon.class.getDeclaredField("authenticator");
                    field.setAccessible(true);
                    field.set(wagon, authenticator);
                    return wagon;
                }
                return null;
            }

            public void release(Wagon wagon) {

            }
        });
        
        return locator.getService(RepositorySystem.class);
    }
}
