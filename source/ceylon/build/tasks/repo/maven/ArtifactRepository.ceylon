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

"""
   A repository hosting artifacts."""
shared interface ArtifactRepository
{

    """The (case-sensitive) type of the repository, for example "default"."""
    shared formal String contentType;

    "The (case-sensitive) identifier, never [[null]]."
    shared formal String id;

}
