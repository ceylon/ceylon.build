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
   A repository on the local file system used to cache contents of remote repositories and to store locally installed
   artifacts. Note that this class merely describes such a repository, actual access to the contained artifacts is
   handled by a [[org.sonatype.aether.repository::LocalRepositoryManager]] which is usually determined from the [[contentType]] of
   the repository."""
shared final class LocalRepository(basedir, contentType ="")
    satisfies ArtifactRepository
{
	shared actual String contentType;

    shared actual String id = "local";

    "Gets the base directory of the repository, a [[String]] or a [[File]]."
    shared String|File basedir;

	shared actual String string = "``basedir`` (``contentType``)";
}
