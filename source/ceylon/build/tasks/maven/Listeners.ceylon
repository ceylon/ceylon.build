import ceylon.build.task { Writer }
import org.sonatype.aether { RepositoryListener, RepositoryEvent }
import org.sonatype.aether.transfer { TransferListener, TransferEvent }

shared class BuildTransferListener(Writer writer) satisfies TransferListener {
    
    String t = "Transfer: ";
    String c = process.propertyValue("user.home")?.plus("/.ceylon/cache") else "Ceylon cache";

    shared actual void transferCorrupted(TransferEvent e) {
        writer.error("``t`` Corruption detected. Please clear out ``e.resource.resourceName`` from ``c``");
        if (exists ee = e.exception) {
            writer.exception(ee);
        }
    }
    
    shared actual void transferFailed(TransferEvent e) {
        writer.error("``t`` Failed. Please clear out ``e.resource.resourceName`` from ``c``");
        if (exists ee = e.exception) {
            writer.exception(ee);
        }
    }
    
    shared actual void transferInitiated(TransferEvent e) {
        writer.info("``t`` for ``e.resource.resourceName`` initiated");
    }
    
    shared actual void transferProgressed(TransferEvent e) {
        writer.info("``t`` ``e.resource.contentLength > 0 then (e.dataLength/e.resource.contentLength) * 100 else e.dataLength/1000`` ``e.resource.contentLength>0 then "%" else "KB"`` transferred");
    }
    
    shared actual void transferStarted(TransferEvent e) {
        writer.info("``t`` started for ``e.resource.resourceName``");
    }
    
    shared actual void transferSucceeded(TransferEvent e) {
        writer.info("``t`` successful for ``e.resource.resourceName``");
    }
    

}

shared class BuildRepositoryListener(Writer writer) satisfies RepositoryListener {

    String r = "Repository: ";
    
    shared actual void artifactDeployed(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is deployed");
    }
    
    shared actual void artifactDeploying(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is deploying ...");
    }
    
    shared actual void artifactDescriptorInvalid(RepositoryEvent e) {
        writer.error("``r``Artifact ``e.artifact`` is invalid");
        if (exists ee = e.exception) {
            writer.exception(ee);
        }
    }
    
    shared actual void artifactDescriptorMissing(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is missing a descriptor");
    }
    
    shared actual void artifactDownloaded(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` has been downloaded");
    }
    
    shared actual void artifactDownloading(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is downloading");
    }
    
    shared actual void artifactInstalled(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is installed");
    }
        
    shared actual void artifactInstalling(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is installing");
    }
     
    shared actual void artifactResolved(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` has been resolved in ``e.repository``");
    }
    
    shared actual void artifactResolving(RepositoryEvent e) {
        writer.info("``r``Artifact ``e.artifact`` is being resolved");
    }
     
    shared actual void metadataDeployed(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is deployed");
    }
    
    shared actual void metadataDeploying(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is deploying");
    }
    
    shared actual void metadataDownloaded(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is downloaded");
    }
    
    shared actual void metadataDownloading(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is downloading");
    }
    
    shared actual void metadataInstalled(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is installed");
    }
    
    shared actual void metadataInstalling(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is installing");
    }
      
    shared actual void metadataInvalid(RepositoryEvent e) {
        writer.error("``r``Metadata for Artifact ``e.artifact`` is invalid");
        if (exists ee = e.exception) {
            writer.exception(ee);
        }
    }
     
    shared actual void metadataResolved(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is resolved");
    }
    
    shared actual void metadataResolving(RepositoryEvent e) {
        writer.info("``r``Metadata for Artifact ``e.artifact`` is resolving");
    }
}