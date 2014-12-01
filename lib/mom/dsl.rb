# encoding: utf-8

module Mom
  module DSL

    class AlreadyRegistered < StandardError
      def initialize(name)
        super("#{name.inspect} is already registered")
      end
    end # AlreadyRegistered

    def self.fail_if_already_registered(name, items)
      fail(AlreadyRegistered.new(name)) if items.key?(name)
    end

    class Schema
      include Concord.new(:default_options, :definitions)

      def self.call(default_options, definitions = {}, &block)
        new(default_options, definitions).call(&block)
      end

      public :definitions

      def initialize(default_options, definitions = {})
        super(Definition::DEFAULT_OPTIONS.merge(default_options), definitions)
        @constraints = Mom::Constraint.empty
      end

      def call(&block)
        instance_eval(&block)
        self
      end

      def constraints(&block)
        return @constraints unless block_given?
        @constraints = Constraint.call(&block)
      end

      def entity(name, options = EMPTY_HASH, &block)
        DSL.fail_if_already_registered(name, definitions)

        definition = Definition.build(
          name, default_options.merge(options), &block
        )

        definitions.update(definition.definitions)
      end
    end # Schema

    class Entity
      include Concord.new(:entity_name, :default_options, :attributes)

      POSITIVE_INFINITY = 1.0 / 0

      def self.call(entity_name, options, &block)
        instance = new(entity_name, options, {})
        instance.instance_eval(&block) if block
        instance.attributes
      end

      public :attributes

      def map(name, *args)
        fail_if_already_registered(name)

        attributes[name] = Definition::Attribute::Primitive.build(name, default_options, args)
      end

      def embed(cardinality, name, options = EMPTY_HASH, &block)
        fail_if_already_registered(name)

        attributes[name] = Definition::Attribute::Entity.build(
          cardinality:        cardinality,
          name:               name,
          parent_entity_name: entity_name,
          default_options:    default_options,
          options:            options,
          block:              block
        )
      end

      private

      def fail_if_already_registered(name)
        DSL.fail_if_already_registered(name, attributes)
      end

      def n
        POSITIVE_INFINITY
      end

    end # Entity

    class Constraint
      include Concord.new(:registry)

      public :registry

      def self.call(registry = {}, &block)
        instance = new(registry)
        instance.instance_eval(&block) if block
        Registry.new(instance.registry)
      end

      def use(library)
        library.each { |name, provider| add(name, provider) }
      end

      def add(name, provider = Undefined, &block)
        DSL.fail_if_already_registered(name, registry)

        registry[name] = block ? Mom::Constraint.build(&block) : provider
      end
    end # Constraint
  end # DSL
end # Mom
