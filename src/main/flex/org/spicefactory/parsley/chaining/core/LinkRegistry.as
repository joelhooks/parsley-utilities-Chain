package org.spicefactory.parsley.chaining.core
{
    public interface LinkRegistry
    {
        function addLink(link:Link):void;

        function getLinkForCommandClass(commandClass:Class):Link;
    }
}