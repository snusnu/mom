# encoding: utf-8

module Mom
  class Morpher
    class Builder
      class Attribute

        class Primitive < self
          register Definition::Attribute::Primitive

          def initialize(*)
            super
            @constraint_options = options.reject { |name, _|
              Definition::Attribute::OPTIONS.include?(name)
            }
          end

          private

          attr_reader :constraint_options

          def node
            environment.constraint(attribute.constraint, constraint_options)
          end
        end # Primitive
      end # Attribute
    end # Builder
  end # Morpher
end # Mom
