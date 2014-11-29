# encoding: utf-8

module Mom
  class Morpher
    class Builder
      class Attribute
        class Entity < self

          include AbstractType

          abstract_method :definition

          def self.new(attribute, *args)
            return super if self < Entity
            klass = attribute.embed? ? Embedded : Referenced
            klass.new(attribute, *args)
          end

          def initialize(attribute, *args)
            super
            @entity_name = attribute.entity_name
          end

          private

          attr_reader :entity_name

          def node
            builder.update(definition: definition).call
          end

          class Embedded < self

            def definition
              @definition = attribute.definition(environment)
            end
          end # Embedded

          class Referenced < self
            attr_reader :definition

            def initialize(*)
              super
              @definition = attribute.definition(environment)
            end
          end # Referenced
        end # Entity

        module Collection

          def self.call(attribute, *args)
            new(attribute, *args).call
          end

          def self.new(attribute, *args)
            klass = attribute.embed? ? Embedded : Referenced
            klass.new(attribute, *args)
          end

          private

          def node
            s(:map, super)
          end

          class Embedded < Entity::Embedded
            include Collection
          end

          class Referenced < Entity::Referenced
            include Collection
          end
        end # Collection

      end # Attribute
    end # Builder
  end # Morpher
end # Mom
