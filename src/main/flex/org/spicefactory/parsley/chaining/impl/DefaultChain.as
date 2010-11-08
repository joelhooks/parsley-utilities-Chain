package org.spicefactory.parsley.chaining.impl
{
    import flash.utils.Dictionary;

    import org.spicefactory.lib.reflect.ClassInfo;
    import org.spicefactory.parsley.chaining.core.*;
    import org.spicefactory.parsley.config.Configuration;
    import org.spicefactory.parsley.core.context.Context;
    import org.spicefactory.parsley.core.context.provider.Provider;
    import org.spicefactory.parsley.core.events.ContextEvent;
    import org.spicefactory.parsley.core.messaging.MessageProcessor;
    import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
    import org.spicefactory.parsley.core.messaging.receiver.MessageInterceptor;
    import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
    import org.spicefactory.parsley.core.scope.ScopeName;
    import org.spicefactory.parsley.processor.messaging.receiver.DefaultMessageInterceptor;

    public class DefaultChain implements Chain
    {
        private static const INTERCEPT_CONTEXT_MESSAGES:String = "interceptContextMessages";

        private var _firstLink:Link;

        public function get firstLink():Link
        {
            return _firstLink;
        }

        public function set firstLink(value:Link):void
        {
            _firstLink = value;
        }

        public var scope:String = ScopeName.LOCAL;

        private var _messageSelectorRegistry:Dictionary;

        public function get messageSelectorRegistry():Dictionary
        {
            return _messageSelectorRegistry ||= new Dictionary();
        }

        public function set messageSelectorRegistry(value:Dictionary):void
        {
            _messageSelectorRegistry = value;
        }

        private var _currentLink:Link;

        public function get currentLink():Link
        {
            return _currentLink;
        }

        public function set currentLink(value:Link):void
        {
            _currentLink = value;
        }

        private var _linkRegistry:LinkRegistry;

        public function get linkRegistry():LinkRegistry
        {
            return _linkRegistry ||= new DefaultLinkRegistry();
        }

        public function set linkRegistry(value:LinkRegistry):void
        {
            _linkRegistry = value;
        }

        private var _config:Configuration;

        public function get config():Configuration
        {
            return _config;
        }

        public function set config(value:Configuration):void
        {
            _config = value;
        }

        private var _processMessageFunction:Function;

        public function get processMessageFunction():Function
        {
            return _processMessageFunction ||= processContextMessage;
        }

        public function set processMessageFunction(value:Function):void
        {
            _processMessageFunction = value;
        }

        public function DefaultChain(config:Configuration=null)
        {
            _config = config;
        }

        private function processContextMessage(message:Object):void
        {
            var selector:String = getSelector(message);

            if (currentLink.hasConnectionforMessage(message, selector))
                executeMessage(message);
        }

        private function executeMessage(message:Object):void
        {
            var selector:String = getSelector(message);
            var transition:LinkConnection = currentLink.getConnectionTarget(message, selector);
            var transitionToLink:Link = transition.toLink;
            var toLink:Link = linkRegistry.getLinkForCommandClass(transitionToLink.commandClass);

            currentLink = toLink;

            toLink.executeMessageCommand(message);
        }

        private function getSelector(forMessage:Object):String
        {
            var type:Class = ClassInfo.forInstance(forMessage).getClass();
            var selector:String = messageSelectorRegistry[type];

            if(!selector)
                selector = messageSelectorRegistry[Object];

            return selector;
        }

        public function start():void
        {
            if (!config)
                throw new Error("Parsely configuration must be present to start the chain.");

            registerChainWithContext();
            registerMessageIntercept();
            config.context.addEventListener(ContextEvent.INITIALIZED, context_configuredHandler);
        }

        private function registerChainWithContext():void
        {
            var chainDef:SingletonObjectDefinition = config.builders
                    .forInstance(this)
                    .asSingleton()
                    .build();

            config.registry.registerDefinition(chainDef);
        }

        private function registerMessageIntercept():void
        {
            var registry:MessageReceiverRegistry = config.context.scopeManager.getScope(scope).messageReceivers;
            var interceptor:MessageInterceptor = new DefaultMessageInterceptor(Provider.forInstance(this), INTERCEPT_CONTEXT_MESSAGES, Object);
            registry.addInterceptor(interceptor);
        }

        /**
         * Parsley message interceptor to listen for LOCAL scoped messages.
         *
         * @param processor
         */
        public function interceptContextMessages(processor:MessageProcessor):void
        {
            processMessageFunction.call(this, processor.message);
            processor.proceed();
        }

        private function context_configuredHandler(event:ContextEvent):void
        {
            executeFirstLinkCommand();
            Context(event.target).removeEventListener(ContextEvent.INITIALIZED, context_configuredHandler)
        }

        private function executeFirstLinkCommand():void
        {
            if (firstLink)
            {
                var commandClass:Class = firstLink.commandClass;
                var commandInstance:Object = new commandClass();

                firstLink.executeCommandInstance(commandInstance);
            }
        }

        public function addLink(link:Link):Link
        {
            linkRegistry.addLink(link);

            if (!currentLink)
                currentLink = link;

            return link;
        }
    }
}