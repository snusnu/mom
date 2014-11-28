# encoding: utf-8

module Mom
  module DSL

    class AlreadyRegistered < StandardError
      def initialize(name)
        super("#{name.inspect} is already registered")
      end
    end # AlreadyRegistered

    class Schema
      include Concord.new(:default_options, :definitions)

      DEFAULT_OPTIONS = Mom::Definition::DEFAULT_OPTIONS

      def self.call(default_options, definitions = {}, &block)
        instance = new(default_options, definitions)
        instance.instance_eval(&block) if block
        instance.definitions
      end

      def self.new(default_options, definitions)
        super(DEFAULT_OPTIONS.merge(default_options), definitions)
      end

      public :definitions

      def register(name, options = EMPTY_HASH, &block)
        fail(AlreadyRegistered.new(name)) if definitions.key?(name)

        definitions[name] = Mom::Definition.build(
          name, default_options.merge(options), &block
        )
      end
    end # Schema

    class Definition
      include Concord.new(:entity_name, :default_options, :header)

      def self.call(entity_name, options, header = Set.new, &block)
        instance = new(entity_name, options, header)
        instance.instance_eval(&block) if block
        instance.header
      end

      public :header

      def map(name, *args)
        header << Mom::Definition::Attribute::Primitive.build(name, default_options, args)
      end

      def wrap(name, options = EMPTY_HASH, &block)
        header << Mom::Definition::Attribute::Entity.build(
          name,
          { entity: :"#{entity_name}.#{name}" }.merge(options),
          default_options,
          block
        )
      end

      def group(name, options = EMPTY_HASH, &block)
        header << Mom::Definition::Attribute::Collection.build(
          name,
          { entity: :"#{entity_name}.#{Inflecto.singularize(name.to_s)}" }.merge(options),
          default_options,
          block
        )
      end
    end # Definition
  end # DSL
end # Mom
