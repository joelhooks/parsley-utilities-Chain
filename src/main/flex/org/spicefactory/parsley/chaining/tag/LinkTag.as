package org.spicefactory.parsley.chaining.tag
{
    import org.spicefactory.parsley.chaining.core.Chain;
    import org.spicefactory.parsley.chaining.core.Link;
    import org.spicefactory.parsley.chaining.core.LinkConnection;
    import org.spicefactory.parsley.chaining.impl.DefaultLink;
    import org.spicefactory.parsley.config.Configuration;

    [DefaultProperty("connections")]
    /**
     * Defines a Chain Link in MXML parsley configuration.
     */
    public class LinkTag
    {
        public var id:String;

        /**
         * A link will execute a command when it is entered.
         */
        public var commandClass:Class;

        private var _linkClass:Class;

        public function get linkClass():Class
        {
            return _linkClass ||= DefaultLink;
        }

        public function set linkClass(value:Class):void
        {
            _linkClass = value;
        }

        private var _link:Link;

        public function get link():Link
        {
            return _link ||= new linkClass();
        }

        public function set link(value:Link):void
        {
            _link = value;
        }

        [ArrayElementType("org.spicefactory.parsley.chaining.tag.LinkConnectionTag")]
        /**
         * A link can contain a series of transitions to other links
         * that occur in response to event messages.
         */
        public var connections:Array = [];

        /**
         * @copy org.spicefactory.parsley.tag.messaging.AbstractMessageReceiverDecorator#type
         */
        public var messageType:Class;

        [Attribute]
        /**
         * @copy org.spicefactory.parsley.tag.messaging.AbstractMessageReceiverDecorator#selector
         */
        public var selector:*;

        [Ignore]
        /**
         * @copy org.spicefactory.parsley.tag.messaging.MessageHandlerDecorator#messageProperties
         */
        public var messageProperties:Array;

        /**
         * @copy org.spicefactory.parsley.tag.messaging.AbstractMessageReceiverDecorator#order
         */
        public var order:int = int.MAX_VALUE;

        /**
         * The name of the method that executes the command.
         * If omitted the default is "execute".
         * The presence of an execution method in the
         * target instance is required.
         */
        public var execute:String = "execute";

        /**
         * The name of the method to invoke for the result.
         * If omitted the framework will look for a method named "result".
         * A result method is optional, if it does not exist no result will
         * be passed to the command instance.
         */
        public var result:String;

        /**
         * The name of the method to invoke in case of errors.
         * If omitted the framework will look for a method named "error".
         * An error method is optional, if it does not exist no error value will
         * be passed to the command instance.
         */
        public var error:String;

        public function process(config:Configuration, chain:Chain):Link
        {
            link.id = id;
            link.config = config;

            if (commandClass)
                link.commandClass = commandClass;
            else
                throw new Error("Link " + id + " does not execute a command.");

            processConnectionTags(chain);

            return link;
        }

        private function processConnectionTags(withChain:Chain):void
        {
            for each(var connectionTag:LinkConnectionTag in connections)
            {
                var connection:LinkConnection = connectionTag.process(withChain);
                link.addConnection(connection);
            }
        }

        /**
         * @private
         */
        public function initialized(document:Object, id:String):void
        {
            this.id = id;
        }
    }
}