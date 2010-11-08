package org.spicefactory.parsley.chaining.impl
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;

    import org.spicefactory.lib.reflect.ClassInfo;
    import org.spicefactory.parsley.chaining.core.*;
    import org.spicefactory.parsley.config.Configuration;
    import org.spicefactory.parsley.core.context.Context;
    import org.spicefactory.parsley.core.context.DynamicObject;
    import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

    public class DefaultLink implements Link
    {
        private static var verifiedCommandClasses:Dictionary = new Dictionary();

        private var _id:String;
        public function get id():String
        {
            return _id;
        }

        public function set id(value:String):void
        {
            _id = value;
        }

        public var transitioningTo:Boolean;
        public var calledFrom:DefaultLink;

        private var _commandClass:Class;

        public function get commandClass():Class
        {
            return _commandClass;
        }

        public function set commandClass(value:Class):void
        {
            _commandClass = value;

            validateCommandHasExecuteFunction();
            registerCommand();
        }

        private var _execute:String;

        public function get execute():String
        {
            return _execute ||= "execute";
        }

        public function set execute(value:String):void
        {
            _execute = value;

            revalidateCommandClass();
        }

        private function registerCommand():void
        {
            var commandDef:DynamicObjectDefinition = config.builders
                    .forInstance(commandClass)
                    .asDynamicObject()
                    .build();
            config.registry.registerDefinition(commandDef);
        }

        private var _config:Configuration;

        public function get config():Configuration
        {
            return _config;
        }

        public function set config(value:Configuration):void
        {
            _config = value;

            config.context.addDynamicObject(this);
        }

        protected var connectionMap:Dictionary = new Dictionary();
        public var chain:Chain;

        public function addConnection(connection:LinkConnection):void
        {
            if(!connectionMap[connection.messageType])
                connectionMap[connection.messageType] = new Dictionary();

            if (connectionMap[connection.messageType][connection.selector])
                throw new Error("A connection for this message already exists. You may only have one connection per message");
            connectionMap[connection.messageType][connection.selector] = connection;
        }

        public function hasConnectionforMessage(message:Object, selector:String):LinkConnection
        {
            var type:Class = ClassInfo.forInstance(message).getClass();
            var connection:LinkConnection;

            if(connectionMap[type])
                connection = connectionMap[type][selector];
            else if(connectionMap[Object])
                connection = connectionMap[Object][selector];

            return connection;
        }

        public function getConnectionTarget(message:Object, selector:String):LinkConnection
        {
            var connection:LinkConnection = hasConnectionforMessage(message, selector);
            return connection;
        }

        public function executeMessageCommand(message:Object):void
        {
            var instance:Object = new commandClass();
            executeCommandInstance(instance, message)
        }

        public function executeCommandInstance(commandInstance:Object, message:Object = null):void
        {
            var dynamicObject:DynamicObject = createCommandInContext(commandInstance);
            var commandHasExecute:Boolean = commandInstance[execute] is Function;
            if(commandHasExecute && message)
                commandInstance[execute].call(null, message);
            else if (commandHasExecute)
                commandInstance[execute].call(null);
            else
                throw new Error(commandInstance.toString() + " does not have function " + execute);

            dynamicObject.remove();
        }

        private function createCommandInContext(instance:Object):DynamicObject
        {
            var context:Context = config.context;
            return context.addDynamicObject(instance);
        }

        private function revalidateCommandClass():void
        {
            if (commandClass)
            {
                verifiedCommandClasses[commandClass] = false;
                validateCommandHasExecuteFunction();
            }
        }

        private function validateCommandHasExecuteFunction():void
        {
            var type:XML = describeType(commandClass);

            if(verifiedCommandClasses[commandClass])
                return;
            verifiedCommandClasses[commandClass] = type.factory.method.(@name == execute).length();
            if (!verifiedCommandClasses[commandClass])
                throw new Error("A link can only execute a class that has an 'execute' method. [" + id + "]");
        }
    }
}