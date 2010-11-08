package org.spicefactory.parsley.chaining.tag
{
    import mx.core.IMXMLObject;

    import org.spicefactory.parsley.chaining.core.Chain;
    import org.spicefactory.parsley.chaining.core.Link;
    import org.spicefactory.parsley.chaining.impl.DefaultChain;
    import org.spicefactory.parsley.config.Configuration;
    import org.spicefactory.parsley.config.RootConfigurationElement;

    [DefaultProperty("links")]
    /**
     * Tag definition for a Chain to be used in a Parsley configuration MXML declaritively.
     */
    public class ChainTag implements RootConfigurationElement, IMXMLObject
    {
        public var id:String;
        public var autoStart:Boolean = true;

        public var firstLink:Object;

        private var _chainClass:Class;

        public function get chainClass():Class
        {
            return _chainClass ||= DefaultChain;
        }

        public function set chainClass(value:Class):void
        {
            _chainClass = value;
        }

        private var chain:Chain;

        [ArrayElementType("org.spicefactory.parsley.chaining.tag.LinkTag")]
        /**
         * The links of the chain. Each link represents a state that the Chain
         * can be in.
         */
        public var links:Array;

        /**
         * create the chain and link registry
         * give the chain the registry
         * register the chain objects with Parsley
         * build the links in the chain
         * @param config
         */
        public function process(config:Configuration):void
        {
            chain = new chainClass();
            chain.config = config;

            if(firstLink)
                chain.firstLink = (firstLink as LinkTag).link;

            processLinkTags(config);

            if(autoStart)
                chain.start();
        }

        private function processLinkTags(config:Configuration):void
        {
            for each(var linkTag:LinkTag in links)
            {
                var link:Link = linkTag.process(config, chain);
                chain.addLink(link);
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