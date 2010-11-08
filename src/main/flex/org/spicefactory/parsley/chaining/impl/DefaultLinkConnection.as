package org.spicefactory.parsley.chaining.impl
{
    import org.spicefactory.parsley.chaining.core.Link;
    import org.spicefactory.parsley.chaining.core.LinkConnection;

    public class DefaultLinkConnection implements LinkConnection
    {
        private var _id:String;

        public function get id():String
        {
            return _id;
        }

        public function set id(value:String):void
        {
            _id = value;
        }

        private var _onMessage:Object;

        public function get onMessage():Object
        {
            return _onMessage;
        }

        public function set onMessage(value:Object):void
        {
            _onMessage = value;
        }

        /**
         * The event type that will trigger the transition.
         */
        private var _selector:String;

        public function get selector():String
        {
            return _selector ||= "type";
        }

        public function set selector(value:String):void
        {
            _selector = value;
        }

        /**
         * The link that will be transitioned to.
         */
        private var _toLink:Link;

        public function get toLink():Link
        {
            return _toLink;
        }

        public function set toLink(value:Link):void
        {
            _toLink = value;
        }

        private var _messageType:Class;

        public function get messageType():Class
        {
            return _messageType ||= Object;
        }

        public function set messageType(value:Class):void
        {
            _messageType = value;
        }


    }
}