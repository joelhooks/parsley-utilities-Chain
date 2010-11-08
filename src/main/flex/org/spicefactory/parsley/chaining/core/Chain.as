package org.spicefactory.parsley.chaining.core
{
    import flash.utils.Dictionary;

    import org.spicefactory.parsley.config.Configuration;

    public interface Chain
    {
        /**
         * the first or initial link in the chain.
         */
        function get firstLink():Link

        function set firstLink(value:Link):void

        /**
         * a registry of all of the message selectors by type and
         * the property that works as the selector for the message
         * type.
         */
        function get messageSelectorRegistry():Dictionary

        function set messageSelectorRegistry(value:Dictionary):void

        /**
         * The link that the chain is currently on.
         */
        function get currentLink():Link;

        function set currentLink(value:Link):void;

        /**
         * A registry that holds references to all of the links
         * within this chain.
         * @return
         */
        function get linkRegistry():LinkRegistry;

        function set linkRegistry(value:LinkRegistry):void;

        /**
         * this is the Parsley <code>Configuration</code> for the <code>Context</code>
         * this chain is defined within.
         */
        function get config():Configuration;

        function set config(value:Configuration):void;

        /**
         * activates the chain after configuration/initialization is complete.
         */
        function start():void;


        /**
         * add a <code>Link</code> to the <code>Chain</code>
         *
         * @param link
         * @return
         */
        function addLink(link:Link):Link;
    }
}