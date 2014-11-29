# encoding: utf-8

module Mom
  class Morpher
    class Builder

      class Attribute

        include AbstractType
        include Concord.new(:attribute, :environment, :builder)
        include Procto.call

        include ::Morpher::NodeHelpers

        def initialize(*)
          super
          @options = attribute.options
        end

        def call
          s(:key_transform, attribute.old_key, attribute.new_key, node)
        end

        private

        attr_reader :options

      end # Attribute
    end # Builder
  end # Morpher
end # Mom
