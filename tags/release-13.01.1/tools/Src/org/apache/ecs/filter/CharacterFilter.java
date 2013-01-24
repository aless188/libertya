/*
 * Copyright (c) 1999 The Java Apache Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgment:
 *    "This product includes software developed by the Java Apache
 *    Project. <http://java.apache.org/>"
 *
 * 4. The names "Java Apache Element Construction Set", "Java Apache ECS" and
 *    "Java Apache Project" must not be used to endorse or promote products
 *    derived from this software without prior written permission.
 *
 * 5. Products derived from this software may not be called
 *    "Java Apache Element Construction Set" nor "Java Apache ECS" appear
 *    in their names without prior written permission of the
 *    Java Apache Project.
 *
 * 6. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the Java Apache
 *    Project. <http://java.apache.org/>"
 *
 * THIS SOFTWARE IS PROVIDED BY THE JAVA APACHE PROJECT "AS IS" AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE JAVA APACHE PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Java Apache Project. For more information
 * on the Java Apache Project please see <http://java.apache.org/>.
 *
 */
package org.apache.ecs.filter;

import org.apache.ecs.Filter;
import org.apache.ecs.Entities;
import java.text.StringCharacterIterator;
import java.text.CharacterIterator;
/**
    This class creates a Filter object.  The default characters filtered are:<br>
    " ' & < >
    <p>
    For example:

    <pre><code>
    Filter filter = new CharacterFilter();
    filter.addAttribute("$","dollar");
    filter.addAttribute("#",Entities.POUND);

    P p = new P();
    p.setFilter(filter);

    Document doc = new Document();
    doc.getBody().addElement(p);
    </pre></code>

    The filter is applied when the addElement() method is called.

    @version $Id: CharacterFilter.java,v 1.2 2001/11/06 03:43:33 jjanke Exp $
    @author <a href="mailto:snagy@servletapi.com">Stephan Nagy</a>
    @author <a href="mailto:jon@clearink.com">Jon S. Stevens</a>
*/
public class CharacterFilter extends java.util.Hashtable implements Filter
{
    /**
        Private initializer. 
        " ' & < > are the default filters.
    */
    {
        addAttribute("\"",Entities.QUOT);
        addAttribute("'",Entities.LSQUO);
        addAttribute("&",Entities.AMP);
        addAttribute("<",Entities.LT);
        addAttribute(">",Entities.GT);
    }

    public CharacterFilter()
    {
		super(4);
    }

    /** Returns the name of the filter */
    public String getInfo()
    {
        return "CharacterFilter";
    }

    /**
        Register things to be filtered.
    */
    public Filter addAttribute(String name,Object attribute)
    {
        this.put(name,attribute);
        return this;
    }

    /**
        Remove things to be filtered.
    */
    public Filter removeAttribute(String name)
    {
        try
        {
            this.remove(name);
        }
        catch ( Exception e )
        {
        }
        return this;
    }

    /**
        Check to see if something is going to be filtered.
    */
    public boolean hasAttribute(String key)
    {
        return(this.containsKey(key));
    }

    /**
        Perform the filtering operation.
    */
    public String process(String to_process)
    {
        if ( to_process == null || to_process.length() == 0 )
            return "";

        StringBuffer bs = new StringBuffer(to_process.length() + 50);
        StringCharacterIterator sci = new StringCharacterIterator(to_process);
        String tmp = null;

        for (char c = sci.first(); c != CharacterIterator.DONE; c = sci.next())
        {
            tmp = String.valueOf(c);

            if (hasAttribute(tmp))
                tmp = (String) this.get(tmp);

            bs.append(tmp);
        }
        return(bs.toString());
    }
}
