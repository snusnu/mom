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

      DEFAULT_OPTIONS = Definition::DEFAULT_OPTIONS

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
        DSL.fail_if_already_registered(name, definitions)

        definition = Definition.build(
          name, default_options.merge(options), &block
        )

        definitions.update(definition.definitions)
      end
    end # Schema

    class Entity
      include Concord.new(:entity_name, :default_options, :attributes)

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

      def wrap(name, options = EMPTY_HASH, &block)
        fail_if_already_registered(name)

        attributes[name] = Definition::Attribute::Entity.build(
          name:               name,
          parent_entity_name: entity_name,
          default_options:    default_options,
          options:            options,
          block:              block
        )
      end

      def group(name, options = EMPTY_HASH, &block)
        fail_if_already_registered(name)

        attributes[name] = Definition::Attribute::Collection.build(
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

    end # Entity
  end # DSL
end # Mom
