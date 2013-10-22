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

"A dependency to some artifact. <em>Note:</em> Instances of this class are immutable."
shared final class Dependency(artifact, scope="", optional = false, exclusions = {} )
{
    "The artifact being depended on."
    Artifact artifact;
    
    "The scope of the dependency. The scope defines in which context this dependency is relevant.

     Return the scope or an empty string if not set."
    String scope;

    "Indicates whether this dependency is optional or not. Optional dependencies can be ignored in some contexts.
     
     Return [[true]] if the dependency is (definitively) optional, [[false]] otherwise."
    Boolean optional;

    "The exclusions for this dependency. Exclusions can be used to remove transitive dependencies during
     resolution.

     Returns the (read-only) exclusions"
    shared {Exclusion *} exclusions;

    shared Boolean hasEquivalentExclusions( Collection<Exclusion> exclusions ) => this.exclusions.equals(exclusions);

    shared actual String string = "``artifact`` (``scope````optional==true then "?" else ""``)";
}


"""
   An exclusion of one or more transitive dependencies. <em>Note:</em> Instances of this class are immutable.""" 
see (`value Dependency.exclusions`)
shared final class Exclusion(groupId = "", artifactId = "", classifier = "", extension ="")
{
    "The group identifier for artifacts to exclude."
    String groupId;
    
    "The artifact identifier for artifacts to exclude."
    String artifactId;
    
    "The classifier for artifacts to exclude."
    String classifier;
    
    "The file extension for artifacts to exclude."
    String extension;
    
    shared actual String string = "``groupId``:``artifactId``:``extension````classifier.empty then ":"+classifier else ""``";
}