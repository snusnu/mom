# encoding: utf-8

module Mom
  module DSL

    class AlreadyRegistered < StandardError
      def initialize(name)
        super("#{name.inspect} is already registered")
      end
    end # AlreadyRegistered

    class Environment
      include Concord.new(:default_options, :definitions)

      public :definitions

      def register(name, options = EMPTY_HASH, &block)
        fail(AlreadyRegistered.new(name)) if definitions.key?(name)

        definitions[name] = Mom::Definition.build(
          name, default_options.merge(options), &block
        )
      end
    end # Environment

    class Definition
      include Concord.new(:entity_name, :default_options, :header)

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
