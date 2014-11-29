# encoding: utf-8

module Mom
  class Morpher
    class Builder
      class Attribute
        class Entity < self
          register Definition::Attribute::Entity

          def initialize(attribute, *args)
            super
            @definition = attribute.definition(environment)
          end

          private

          def node
            builder.update(definition: @definition).call
          end
        end # Entity

        class Collection < Entity
          register Definition::Attribute::Collection

          private

          def node
            s(:map, super)
          end
        end # Collection
      end # Attribute
    end # Builder
  end # Morpher
end # Mom
