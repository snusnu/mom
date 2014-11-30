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
            attribute.collection? ? s(:map, morpher) : morpher
          end

          def morpher
            builder.update(definition: @definition).call
          end
        end # Entity
      end # Attribute
    end # Builder
  end # Morpher
end # Mom
