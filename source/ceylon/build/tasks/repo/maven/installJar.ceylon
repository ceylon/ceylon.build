import ceylon.build.task { Task, Context }
import org.sonatype.aether.repository { RemoteRepository, LocalArtifactRequest, LocalArtifactResult }
import org.apache.maven.repository.internal { MavenRepositorySystemSession }
import org.sonatype.aether.impl.internal { ... }
import org.sonatype.aether.resolution { ArtifactRequest, ArtifactResult, ArtifactResolutionException, ArtifactDescriptorResult }
import org.sonatype.aether.util.artifact { DefaultArtifact }
import org.sonatype.aether.util { DefaultRepositorySystemSession }
import ceylon.file { Resource, parsePath, Path, ExistingResource, Nil, Writer  }
import java.util {JIterator = Iterator }
import org.sonatype.aether.graph { Dependency }
import ceylon.build.tasks.repo.herd { CeylonRepositoryManager }
import ceylon.build.tasks.repo { Util, BuildRepositoryListener, BuildTransferListener }

""" Downloads a remote Maven artifact and installs it to the local
   Ceylon cache repository, usually at `~/.ceylon/cache` with the defined dependencies

   This task does not read Maven settings or write to the Maven repository:
   - does not attempt to resolve and download dependencies
   
   This approach avoid unnecessary recursion and download time, but links the modules properly.
"""
shared Task installJar (
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
        
        LocalArtifactRequest localRequest = LocalArtifactRequest()
                .setArtifact(artifactToCheck);
        
        LocalArtifactResult? localResult = localManager.find(session, localRequest);
        if (exists localResult) {
            if (localResult.available && !overwrite) {
                return true;
            }
        }

        ArtifactRequest request = ArtifactRequest()
            .setArtifact(artifactToCheck)
            .addRepository(newRemoteMavenRepository("remote", mavenRepo));
        
        try {
            ArtifactResult? result = system.resolveArtifact(session, request);
            if (exists result) {
                if (result.resolved) {
                    /*
                    value directDeps = system.readArtifactDescriptor(session, ArtifactDescriptorRequest()
                            .setArtifact(artifactToCheck) //original one
                            .addRepository(newRemoteMavenRepository("remote", mavenRepo)));
                    writeDependencies(directDeps, localManager);
                     */
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
        if (! "test" == dep.scope
                && ! "provided" == dep.scope
                && "jar".equals(dep.artifact.extension)
                && ! dep.optional) {
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
        Writer writer = res.createFile().Overwriter();
        writer.write(deps.string);
        writer.close(null);
    }
}
