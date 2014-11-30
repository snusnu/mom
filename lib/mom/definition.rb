# encoding: utf-8

module Mom

  class Definition

    DEFAULT_OPTIONS = {
      guard:          Hash,
      key_transform: :neutral,
      name_generator: ->(entity_name, attribute_name) { attribute_name }
    }.freeze

    include Concord.new(:entity_name, :default_options, :header)

    public :entity_name
    public :default_options

    def self.build(entity_name, default_options = DEFAULT_OPTIONS, &block)
      opts = { prefix: entity_name }.merge(default_options)

      new(entity_name, opts, DSL::Entity.call(entity_name, opts, &block))
    end

    attr_reader :definitions

    def initialize(*)
      super
      @definitions = anonymous_definitions.update(entity_name => self)
    end

    def attributes
      header.values
    end

    def attribute_names
      header.keys
    end

    def defaults
      header.each_with_object({}) { |(_, attribute), hash|
        if attribute.default_value?
          hash[attribute.old_key] = attribute.default_value
        end
      }
    end

    def anonymous?
      definitions.size > 1
    end

    private

    def anonymous_definitions
      anonymous_embedded_attributes.each_with_object({}) { |attr, h|
        h.update(Hash[attr.anonymous_definition.definitions.to_a])
      }
    end

    def anonymous_embedded_attributes
      attributes.select { |attr| !attr.primitive? && attr.anonymous?  }
    end
  end # Definition
end # Mom
