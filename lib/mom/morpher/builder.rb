# encoding: utf-8

module Mom
  class Morpher
    class Builder

      include AbstractType
      include ::Morpher::NodeHelpers

      include Anima.new(
        :name,
        :definition,
        :environment
      )

      include Anima::Update

      REGISTRY = {}

      abstract_method :call

      def self.call(options)
        REGISTRY.fetch(options.fetch(:name)).new(options).call
      end

      def self.register(name)
        REGISTRY[name] = self
      end

      class Hash < self
        register :hash

        def call
          s(:block,
            *guards,
            *defaults,
            s(:hash_transform, *attributes),
          )
        end
      end # Hash

      class Object < Hash
        register :object

        include anima.add(:entities)

        def call
          s(:block,
            super,
            s(:load_attribute_hash, s(:param, entity))
           )
        end

        private

        def entity
          entities.fetch(definition.entity_name) {
            # TODO nuke the need to know an entity builder
            Entity::Builder[:anima].call(definition)
          }
        end
      end # Object

      private

      def attributes
        definition.attribute_nodes(environment, self)
      end

      def defaults
        values = definition.defaults
        values.any? ? [ s(:merge, values) ] : EMPTY_ARRAY
      end

      def guards
        if guard = definition.default_options[:guard]
          [ s(:guard, s(:primitive, guard)) ]
        else
          EMPTY_ARRAY
        end
      end

    end # Builder
  end # Morpher
end # Mom
