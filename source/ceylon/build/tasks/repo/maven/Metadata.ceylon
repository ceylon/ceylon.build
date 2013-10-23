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

"""
   A piece of repository metadata, e.g. an index of available versions. In contrast to an artifact, which usually exists
   in only one repository, metadata usually exists in multiple repositories and each repository contains a different
   copy of the metadata. <em>Note:</em> Metadata instances are supposed to be immutable. Implementors are strongly advised to obey
   this contract."""
shared interface Metadata
{

    "The group identifier or an empty string if the metadata applies to the entire repository."
    shared formal String groupId;

    "The artifact identifier or an empty string if the metadata applies to the groupId level only."
    shared formal String artifactId;

    "The version or an empty string if the metadata applies to the groupId:artifactId level only"
    shared formal String version;

    "The type of the metadata."
    shared formal String type;

    "The nature of this metadata. The nature indicates to what artifact versions the metadata refers."
    shared formal Nature nature;

    "The file of this metadata. Note that only resolved metadata has a file associated with it, or [[null]] if none."
    shared formal File? file;

    "Gets the specified property. defaultValue is the default value to return in case the property is not set, may be [[null]]."
    shared formal String? property( String key, String defaultValue );

    "The (read-only) properties."
    shared formal Map<String, String> properties;
}

"The nature of the metadata."
shared abstract class Nature() of release | snapshot | releaseOrSnapshot {}

object release extends Nature() {
    string => "RELEASE";
}
object snapshot extends Nature() {
    string => "SNAPSHOT";
}
object releaseOrSnapshot extends Nature() {
    string => "RELEASE_OR_SNAPSHOT";
}

shared object metadata {
    "The metadata refers to release artifacts only."
    shared Nature release = package.release;

    "The metadata refers to snapshot artifacts only."
    shared Nature snapshot = package.snapshot;

    "The metadata refers to either release or snapshot artifacts."
    shared Nature releaseOrSnapshot = package.releaseOrSnapshot;
}