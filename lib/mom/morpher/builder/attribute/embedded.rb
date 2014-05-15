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
            @definitions = environment.definitions
          end

          private

          attr_reader :entity_name
          attr_reader :definitions

          def node
            Builder::Entity.call(builder, definition, environment)
          end

          class Embedded < self

            def definition
              Mom::Definition.build(
                entity_name,
                options,
                &attribute.block
              )
            end
          end # Embedded

          class Referenced < self

            def definition
              definitions[entity_name]
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