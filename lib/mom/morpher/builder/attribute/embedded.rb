# encoding: utf-8

module Mom
  class Morpher
    class Builder
      class Attribute
        class Entity < self
          register Definition::Attribute::Entity

          def self.new(attribute, *args)
            if self < Entity
              super
            elsif attribute.collection?
              Collection.new(attribute, *args)
            else
              super
            end
          end

          class Collection < self
            def node
              s(:map, super)
            end
          end # Collection

          def initialize(attribute, *args)
            super
            @definition = attribute.definition(environment)
          end

          private

          def node
            builder.update(definition: @definition).call
          end
        end # Entity
      end # Attribute
    end # Builder
  end # Morpher
end # Mom
