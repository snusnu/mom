# encoding: utf-8

module Mom
  class Morpher
    class Builder
      class Attribute

        class Primitive < self
          private

          def node
            environment.processor(attribute.processor, options)
          end
        end # Primitive
      end # Attribute
    end # Builder
  end # Morpher
end # Mom