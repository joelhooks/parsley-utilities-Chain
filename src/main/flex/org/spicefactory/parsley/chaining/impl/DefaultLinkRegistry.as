package org.spicefactory.parsley.chaining.impl
{
    import org.spicefactory.parsley.chaining.core.*;

    public class DefaultLinkRegistry implements LinkRegistry
    {
        private var links:Object = {};

        public function addLink(link:Link):void
        {
            if(!link.commandClass)
                throw new Error("Link has no ID")
            links[link.commandClass] = link;
        }

        public function getLinkForCommandClass(commandClass:Class):Link
        {
            return links[commandClass];
        }
    }
}