package org.spicefactory.parsley.chaining.core
{
    public interface LinkConnection
    {
        function get id():String;

        function set id(value:String):void;

        function get onMessage():Object;

        function set onMessage(value:Object):void;

        function get selector():String;

        function set selector(value:String):void;

        function get toLink():Link;

        function set toLink(value:Link):void;

        function get messageType():Class

        function set messageType(value:Class):void
    }
}