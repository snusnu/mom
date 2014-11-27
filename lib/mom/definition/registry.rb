# encoding: utf-8

module Mom
  class Definition

    class Registry

      class AlreadyRegistered < StandardError
        def initialize(name)
          super("#{name.inspect} is already registered")
        end
      end # AlreadyRegistered

      include Concord.new(:default_options, :definitions)
      include Lupo.enumerable(:definitions)

      public :default_options

      def self.build(default_options = DEFAULT_OPTIONS, definitions = {}, &block)
        instance = new(DEFAULT_OPTIONS.merge(default_options), definitions)
        instance.instance_eval(&block) if block
        instance
      end

      # Mutates an optionally given definitions hash
      def initialize(default_options = DEFAULT_OPTIONS, definitions = {})
        super(default_options, definitions)
      end

      def register(name, options = EMPTY_HASH, &block)
        fail(AlreadyRegistered.new(name)) if include?(name)

        definitions[name] = definition(name, options, &block)
      end

      def definition(name, options = EMPTY_HASH, &block)
        Definition.build(name, default_options.merge(options), &block)
      end

      def [](name)
        definitions.fetch(name)
      end

      def include?(name)
        definitions.key?(name)
      end

      def models(builder_name)
        Model::Builder.call(builder_name, self)
      end

      def environment(models, processors = PROCESSORS)
        Environment.new(
          definitions: self,
          models: models,
          processors: processors
        )
      end

    end # Registry
  end # Definition
end # Mom
