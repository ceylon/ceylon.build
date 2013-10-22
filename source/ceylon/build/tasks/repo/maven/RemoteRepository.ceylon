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

import java.util.regex { Pattern {compile}, Matcher }
import ceylon.interop.java { javaString }
import org.sonatype.aether.repository { RepositoryPolicy, Proxy, Authentication }

"A repository on a remote server."
shared final class RemoteRepository(id, contentType, url, policy, mirroredRepositories, 
        proxy = null, authentication = null, isRepositoryManager = false)
    satisfies ArtifactRepository
{
    Pattern? url_PATTERN =
        compile( "([^:/]+(:[^:/]{2,}+(?=://))?):(//([^@/]*@)?([^/:]+))?.*" );

    shared actual String id;

	shared actual String contentType;

    "The (base) URL of this repository."
    String url;

    "The requested repository policy"
    RepositoryPolicy policy;

    "The selected proxy or [[null]] if none."
    shared Proxy? proxy;

    "The selected authentication or [[null]] if none."
    shared Authentication? authentication;

    "The (read-only) repositories being mirrored by this repository."
    shared List<RemoteRepository> mirroredRepositories;

    "Indicates whether this repository refers to a repository manager or not.
     [[true]] if this repository is a repository manager, [[false]] otherwise."
    shared Boolean isRepositoryManager;

    """Gets the protocol part from the repository's URL, for example `file` or `http`. As suggested by RFC
       2396, section 3.1 "Scheme Component", the protocol name should be treated case-insensitively.
       
       Returns the protocol or an empty string if none."""
    shared String getProtocol()
    {
        Matcher? m = url_PATTERN?.matcher( javaString(this.url) );
		if (exists m) {
	        if ( m.matches() )
	        {
	            return m.group( 1 );
	        }
    	}
        return "";
    }

    "Gets the host part from the repository's URL, or an empty string if none."
    shared String getHost()
    {
        Matcher? m = url_PATTERN?.matcher( javaString(this.url) );
        if (exists m) {
	        if ( m.matches() )
	        {
	            String? host = m.group( 5 );
	            if (exists host )
	            {
	                return host;
	            }
	        }
    	}
        return "";
    }
    
    "A short description for connectors and exception messages"
    shared String description = "``id`` (``url``)";

    shared actual String string = "``id`` (``url``, ``contentType``, ``policy.updatePolicy``, ``isRepositoryManager == true then "managed" else ""``)";
}
