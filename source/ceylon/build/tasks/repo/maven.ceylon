import ceylon.build.task { Task, Context }
import org.sonatype.aether.repository { RemoteRepository, LocalArtifactRequest, LocalArtifactResult }
import org.apache.maven.repository.internal { MavenRepositorySystemSession }
import org.sonatype.aether.impl.internal { ... }
import org.sonatype.aether.resolution { ArtifactRequest, ArtifactResult, ArtifactResolutionException, ArtifactDescriptorResult, ArtifactDescriptorRequest }
import org.sonatype.aether.util.artifact { DefaultArtifact }
import org.sonatype.aether.util { DefaultRepositorySystemSession }
import ceylon.file { Resource, parsePath, Path, ExistingResource, Nil, Writer  }
import java.util {JIterator = Iterator }
import org.sonatype.aether.graph { Dependency }

""" Downloads a remote Maven artifact and installs it to the local
   Ceylon user repo under the cache tree

   This task should not interfere with Maven or the Ceylon Module Resolver:
   - does not attempt to define a local repository or read any configuration
   - does not write to the user repo under the `repo` folder
   - does not attempt to write or read the Maven `.m2` repo
   - does not attempt to resolve and download dependencies
   
   The task attempts to create a module.properties from dependencies to enable normal CMR and Ceylon Runtime.
   The usual usage pattern to enable classloading of jar dependencies would then be:
   - define all Maven jars in the build separately
   - only use the top-level jar in module.ceylon
   
   This approach avoid unnecessary recursion and download time, but links the modules properly.
"""
shared Task installMavenJar (
    doc("Group Id (required)")
    String groupId,
    doc("Artifact Id (required)")
    String artifactId,
    doc("version (required)")
    String version,
    doc("Maven repository URL in this format of http://repo1.maven.org/repo/maven2/
         (default: http://repo1.maven.org/maven2/)")
    String mavenRepo = "http://repo1.maven.org/maven2/",
    doc("If true, fetches and overwrites; if false, fetches only if the jar itself does not exist")
    Boolean overwrite = false,
    doc("Fetch sources - only when it actually accesses the network to fetch")
    Boolean sources = false,
    doc("Fetch javadocs - only when it actually accesses the network to fetch")
    Boolean javadocs = false

){
    return function(Context context) {

        value system=Util().lookupSystem();
        value localManager = CeylonRepositoryManager();
        value artifactToCheck = DefaultArtifact( groupId + ":" + artifactId + ":" + version);
        
        DefaultRepositorySystemSession session = MavenRepositorySystemSession()
            .setTransferListener(BuildTransferListener(context.writer))
            .setRepositoryListener(BuildRepositoryListener(context.writer))
            .setTransferErrorCachingEnabled(false)
                .setLocalRepositoryManager(localManager);
        
        if (!overwrite) {
            LocalArtifactRequest localRequest = LocalArtifactRequest()
                    .setArtifact(artifactToCheck);
            
            LocalArtifactResult? localResult = localManager.find(session, localRequest);
            if (exists localResult) {
                if (localResult.available) {
                    return true;
                }
            }
        }
        
        ArtifactRequest request = ArtifactRequest()
            .setArtifact(artifactToCheck)
            .addRepository(newRemoteMavenRepository("remote", mavenRepo));
        
        try {
            ArtifactResult? result = system.resolveArtifact(session, request);
            if (exists result) {
                if (result.resolved) {
                    value directDeps = system.readArtifactDescriptor(session, ArtifactDescriptorRequest()
                            .setArtifact(result.artifact).addRepository(newRemoteMavenRepository("deps", mavenRepo)));
                    writeDependencies(directDeps, localManager);
                    return true;
                }
            }
            return false;
        } catch (ArtifactResolutionException are) {
            are.printStackTrace();
            return false;
        }
    };
}

RemoteRepository newRemoteMavenRepository(String id, String url) {
       return RemoteRepository( id, "default", url);
}

void writeDependencies(ArtifactDescriptorResult directDeps, CeylonRepositoryManager localManager)  {

    StringBuilder deps = StringBuilder();
    deps.append("java.tls=7\n");
    JIterator<Dependency> iter = directDeps.dependencies.iterator();
    while (iter.hasNext()) {
        Dependency dep = iter.next();
        if (!"test" == dep.scope &&
                !"provided" == dep.scope) {
            deps.append(dep.artifact.groupId);
            deps.append(".");
            deps.append(dep.artifact.artifactId);
            deps.append("=");
            deps.append(dep.artifact.version);
            deps.append("\n");
        }
    }

    Path path = parsePath(localManager.repository.basedir.absolutePath 
            + "/" + localManager.getPathForLocalArtifact(directDeps.artifact)).parent;
    
    Resource res = path.childPath("module.properties").resource;
    if (is ExistingResource res) {
        res.delete();
    }
    
    if (is Nil res) {
        Writer writer = res.createFile().writer();
        writer.write(deps.string);
        writer.close(null);
    }
}
