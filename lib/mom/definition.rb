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

      new(entity_name, opts, DSL::Definition.call(entity_name, opts, &block))
    end

    def attribute_nodes(environment, builder)
      header.map { |attribute| attribute.node(environment, builder) }
    end

    def attribute_names
      header.map(&:name)
    end

    def defaults
      header.each_with_object({}) { |attribute, hash|
        if attribute.default_value?
          hash[attribute.old_key] = attribute.default_value
        end
      }
    end
  end # Definition
end # Mom
