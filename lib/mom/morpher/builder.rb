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

      abstract_method :processors

      def self.call(options)
        REGISTRY.fetch(options.fetch(:name)).new(options).call
      end

      def self.register(name)
        REGISTRY[name] = self
      end

      class Hash < self
        register :hash

        private

        def processors
          EMPTY_ARRAY
        end
      end

      class Object < self
        register :object

        include anima.add(:models)

        private

        def processors
          model = models.fetch(definition.entity_name) {
            # TODO nuke the need to know a model builder
            Entity::Builder[:anima].call(definition)
          }
          [ s(:load_attribute_hash, s(:param, model)) ]
        end
      end

      def call
        s(:block,
          *guards,
          *defaults,
          s(:hash_transform, *attributes),
          *processors
        )
      end

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
          [s(:guard, s(:primitive, guard))]
        else
          EMPTY_ARRAY
        end
      end

    end # Builder
  end # Morpher
end # Mom
