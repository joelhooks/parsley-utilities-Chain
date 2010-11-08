package org.spicefactory.parsley.chaining.tag
{
    import mx.core.IMXMLObject;

    import org.spicefactory.parsley.chaining.core.Chain;
    import org.spicefactory.parsley.chaining.core.LinkConnection;
    import org.spicefactory.parsley.chaining.impl.DefaultLinkConnection;

    public class LinkConnectionTag implements IMXMLObject
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

        private var _connectionClass:Class;

        public function get connectionClass():Class
        {
            return _connectionClass ||= DefaultLinkConnection;
        }

        public function set connectionClass(value:Class):void
        {
            _connectionClass = value;
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
         * this event
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

        private var _messageType:Class;

        /**
         * Allows for strong typing of the message class for additional type safety.
         *
         * Default is <code>Object</code>
         */
        public function get messageType():Class
        {
            return _messageType ||= Object;
        }

        public function set messageType(value:Class):void
        {
            _messageType = value;
        }

        /**
         * the <code>Link</code> this connects too
         */
        private var _toLink:LinkTag;

        public function get toLink():LinkTag
        {
            return _toLink;
        }

        public function set toLink(value:LinkTag):void
        {
            _toLink = value;
        }

        public function initialized(document:Object, id:String):void
        {
            this.id = id;
        }

        public function process(chain:Chain):LinkConnection
        {
            connection = new connectionClass();

            connection.toLink = toLink.link;
            connection.selector = selector;
            connection.messageType = messageType;
            connection.onMessage = onMessage;

            chain.messageSelectorRegistry[messageType] = selector;

            return connection
        }

        private var _connection:LinkConnection;

        public function get connection():LinkConnection
        {
            return _connection;
        }

        public function set connection(value:LinkConnection):void
        {
            _connection = value;
        }
    }
}