package org.spicefactory.parsley.chaining.core
{
    import org.spicefactory.parsley.config.Configuration;

    public interface Link
    {
        function get id():String;

        function set id(value:String):void;

        function get commandClass():Class;

        function set commandClass(value:Class):void;

        function get execute():String

        function set execute(value:String):void

        function get config():Configuration;

        function set config(value:Configuration):void;

        function addConnection(transition:LinkConnection):void;

        function hasConnectionforMessage(message:Object, selector:String):LinkConnection;

        function getConnectionTarget(message:Object, selector:String):LinkConnection;

        function executeMessageCommand(message:Object):void;

        function executeCommandInstance(commandInstance:Object, message:Object = null):void

    }
}