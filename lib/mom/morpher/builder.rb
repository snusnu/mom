# encoding: utf-8

module Mom
  class Morpher
    class Builder

      include AbstractType
      include ::Morpher::NodeHelpers

      include Anima.new(
        :definition,
        :environment
      )

      include Anima::Update

      abstract_method :call

      def self.executor(options)
        ::Morpher::Executor::Hybrid.new(evaluator(options))
      end

      def self.evaluator(options)
        ::Morpher.compile(new(options).call)
      end

      class Hash < self
        def call
          s(:block,
            *guards,
            *defaults,
            s(:hash_transform, *attributes),
          )
        end
      end # Hash

      class Object < Hash
        include anima.add(:entities)

        def initialize(_)
          super
          @entity = entities.fetch(definition.entity_name)
        end

        def call
          s(:block,
            super,
            s(:load_attribute_hash, s(:param, @entity))
           )
        end
      end # Object

      private

      def attributes
        definition.attributes.map { |attribute|
          Attribute.call(attribute, environment, self)
        }
      end

      def defaults
        if (values = definition.defaults).any?
          [ s(:merge, values) ]
        else
          EMPTY_ARRAY
        end
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
