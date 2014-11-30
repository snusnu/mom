# encoding: utf-8

module Mom
  class Definition
    class Attribute

      class OptionBuilder
        class Wrap < self
          private

          def local_entity_name
            name
          end
        end

        class Group < self
          private

          def local_entity_name
            Mom.singularize(name)
          end
        end

        include Anima.new(
          :name,
          :parent_entity_name,
          :options,
          :default_options,
          :block
        )

        include Procto.call

        def call
          default_options.merge(local_options).merge!(options)
        end

        private

        def local_options
          {entity: entity_name, prefix: local_entity_name}
        end

        def entity_name
          block ? :"#{parent_entity_name}.#{local_entity_name}" : name
        end
      end # OptionBuilder

      class Entity < self

        OPTION_BUILDER = OptionBuilder::Wrap

        attr_reader :entity_name

        def self.build(config)
          name, block = config.values_at(:name, :block)
          new(name, self::OPTION_BUILDER.call(config), block)
        end

        def initialize(name, options, block)
          super(name, options)

          @entity_name = options.fetch(:entity)
          @anonymous   = !!block
          @definition  = Definition.build(entity_name, options, &block) if anonymous?
        end

        def definition(environment)
          anonymous? ? @definition : environment.definition(entity_name)
        end

        def anonymous_definition
          @definition
        end

        def anonymous?
          @anonymous
        end
      end # Entity

      class Collection < Entity
        OPTION_BUILDER = OptionBuilder::Group
      end # Collection
    end # Attribute
  end # Definition
end # Mom
