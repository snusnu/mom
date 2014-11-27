# encoding: utf-8

module Mom
  class Definition

    class Registry

      class AlreadyRegistered < StandardError
        def initialize(name)
          super("#{name.inspect} is already registered")
        end
      end # AlreadyRegistered

      DEFAULT_OPTIONS = {
        guard:          Hash,
        key_transform: :neutral,
        name_generator: ->(entity_name, attribute_name) { attribute_name }
      }.freeze

      include Concord.new(:default_options, :definitions)
      include Lupo.enumerable(:definitions)

      public :default_options

      def self.build(default_options = DEFAULT_OPTIONS, definitions = EMPTY_HASH, &block)
        instance = new(DEFAULT_OPTIONS.merge(default_options), definitions)
        instance.instance_eval(&block) if block
        instance
      end

      def initialize(default_options = DEFAULT_OPTIONS, definitions = EMPTY_HASH)
        super(default_options.dup, definitions.dup)
      end

      def register(name, options = EMPTY_HASH, &block)
        fail(AlreadyRegistered.new(name)) if definitions.key?(name)

        definition_options = default_options.merge(options)
        definitions[name]  = Definition.build(name, definition_options, &block)
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
