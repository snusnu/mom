# encoding: utf-8

module Mom
  class Morpher
    class Builder

      class Attribute

        include AbstractType
        include Concord.new(:attribute, :environment, :builder)

        include ::Morpher::NodeHelpers

        REGISTRY = {}

        def self.register(attribute_class)
          REGISTRY[attribute_class] = self
        end

        def self.call(attribute, environment, builder)
          REGISTRY[attribute.class].new(attribute, environment, builder).call
        end

        def initialize(*)
          super
          @options = attribute.options
        end

        def call
          s(:key_transform, attribute.old_key, attribute.new_key, node)
        end

        private

        attr_reader :options

        def collection?
          false
        end

      end # Attribute
    end # Builder
  end # Morpher
end # Mom
