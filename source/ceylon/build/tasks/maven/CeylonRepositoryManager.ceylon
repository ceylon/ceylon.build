import org.sonatype.aether.impl.internal { EnhancedLocalRepositoryManager }
import java.io { JFile = File }

import org.sonatype.aether.artifact { Artifact }
import org.sonatype.aether.repository { RemoteRepository, LocalArtifactResult, LocalArtifactRequest }
import ceylon.file { parsePath, Directory, Resource, Nil, File, Link }
import org.sonatype.aether { RepositorySystemSession }

"""
   Maps requests to the local Ceylon cache format
   """
class CeylonRepositoryManager() 
        extends EnhancedLocalRepositoryManager(JFile(process.propertyValue("user.home")?.plus("/.ceylon/cache"))) {

    shared actual String getPathForLocalArtifact( Artifact artifact ) {
        StringBuilder path = StringBuilder();
        path.append( artifact.groupId.replace( ".", "/" ) ).append( "/" );
        path.append( artifact.artifactId ).append( "/" );
        path.append( artifact.version ).append( "/" );
        path.append( artifact.groupId).append(".");
        path.append( artifact.artifactId ).append( "-" );
        path.append( artifact.version );
        if ( artifact.extension.size > 0 ) {
            path.append( "." ).append( artifact.extension );
        }
        return path.string;
    }

    shared actual String getPathForRemoteArtifact( Artifact artifact, RemoteRepository repository, String context ) {
        return getPathForLocalArtifact(artifact);
    }

    shared actual LocalArtifactResult find(RepositorySystemSession session, LocalArtifactRequest localRequest) {
        Resource res = parsePath(repository.basedir.absolutePath 
                + "/" + getPathForLocalArtifact(localRequest.artifact)).resource;
        value result = LocalArtifactResult (localRequest);
        
        switch (res)
        case (is Directory | Link | Nil) {}
        case (is File) {
            result.setAvailable(true);
        }
        
        return result;
    }
}
