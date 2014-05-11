# encoding: utf-8

module Mom
  class Entity
    class Morpher
      class Builder
        class Attribute

          class Primitive < self
            private

            def node
              environment.processor(processor, options)
            end
          end # Primitive
        end # Attribute
      end # Builder
    end # Morpher
  end # Entity
end # Mom
