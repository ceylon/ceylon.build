/*******************************************************************************
 * Copyright (c) 2010, 2012 Sonatype, Inc.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Sonatype, Inc. - initial API and implementation
 *    Digiwave Systems Ltd. - port to Ceylon
 *******************************************************************************/

import ceylon.file { File }

"""A specific artifact. <em>Note:</em> Artifact instances are supposed to be immutable."""
shared interface Artifact {

    "The group identifier."
    shared formal String groupId;

    "The artifact identifier."
    shared formal String artifactId;

    """The version of this artifact, for example "1.0-20100529-1213". Note that in case of meta versions like
       "1.0-SNAPSHOT", the artifact's version depends on the state of the artifact. Artifacts that have been resolved or
       deployed will usually have the meta version expanded."""
    shared formal String version;

    """
       The base version of this artifact, for example "1.0-SNAPSHOT". In contrast to the [[version]], the
       base version will always refer to the unresolved meta version."""
    shared formal String baseVersion;

    """
       Determines whether this artifact uses a snapshot version. 
       [[true]] if the artifact is a snapshot, [[false]] otherwise."""
    shared formal Boolean isSnapshot;

    """
       Gets the classifier of this artifact, for example "sources", or an empty string."""
    shared formal String classifier;

    """
       Gets the (file) extension of this artifact(without leading period), for example "jar" or "tar.gz"."""
    shared formal String extension;

    """
       Gets the file of this artifact. Note that only resolved artifacts have a file associated with them. In general,
       callers must not assume any relationship between an artifact's filename and its coordinates.
        
       The file or [[null]] if the artifact isn't resolved."""
    shared formal File? file;


    """
       Gets the specified property.
       _defaultValue_: The default value to return in case the property is not set, may be [[null]].
       _returns_: The requested property value or [[null]] if the property is not set and no default value was provided."""
    see (`class ArtifactProperties`)
    shared formal String? getProperty( String key, String? defaultValue );

    """
       Gets the properties of this artifact.
       
       The (read-only) properties, never [[null]]."""
    see (`class ArtifactProperties`)
    shared formal Map<String, String> properties;
}
