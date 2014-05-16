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

      include Lupo.enumerable(:definitions)

      attr_reader :default_options

      attr_reader :definitions
      private     :definitions

      def self.build(default_options = DEFAULT_OPTIONS, definitions = EMPTY_HASH, &block)
        instance = new(DEFAULT_OPTIONS.merge(default_options), definitions)
        instance.instance_eval(&block) if block
        instance
      end

      def initialize(default_options = DEFAULT_OPTIONS, definitions = EMPTY_HASH)
        @default_options, @definitions = default_options.dup, definitions.dup
      end

      def register(name, options = EMPTY_HASH, &block)
        if definitions.key?(name)
          fail(AlreadyRegistered.new(name))
        else
          definition_options = @default_options.merge(options)
          definitions[name] = Definition.build(name, definition_options, &block)
        end
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
