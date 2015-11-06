# encoding: utf-8

module Mom
  class Definition
    class Attribute

      class OptionBuilder
        class EV < self
          private

          def local_entity_name
            name
          end
        end

        class EC < self
          private

          def local_entity_name
            Mom.singularize(name)
          end
        end

        include Anima.new(
          :cardinality,
          :name,
          :parent_entity_name,
          :options,
          :default_options,
          :block
        )

        def self.call(options)
          (options.fetch(:cardinality) == 1 ? EV : EC).new(options).call
        end

        def call
          default_options.merge(local_options).merge!(options)
        end

        private

        def local_options
          {
            :cardinality => cardinality,
            :entity      => entity_name,
            :prefix      => local_entity_name
          }
        end

        def entity_name
          if block
            :"#{parent_entity_name}.#{local_entity_name}"
          else
            local_entity_name
          end
        end
      end # OptionBuilder

      class Entity < self

        attr_reader :cardinality
        attr_reader :entity_name

        def self.build(config)
          name, block = config.values_at(:name, :block)
          new(name, OptionBuilder.call(config), block)
        end

        def initialize(name, options, block)
          super(name, options)

          @cardinality = options.fetch(:cardinality)
          @entity_name = options.fetch(:entity)
          @anonymous   = !!block

          if anonymous?
            @definition = Definition.build(
              :entity_name     => entity_name,
              :default_options => options,
              :header          => {},
              :constraints     => {},
              &block
            )
          end
        end

        def definition(environment)
          anonymous? ? @definition : environment.definition(entity_name)
        end

        def collection?
          cardinality.is_a?(Range) || cardinality > 1
        end

        def anonymous_definition
          @definition
        end

        def anonymous?
          @anonymous
        end
      end # Entity
    end # Attribute
  end # Definition
end # Mom
