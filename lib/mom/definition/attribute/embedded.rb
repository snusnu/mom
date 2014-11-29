# encoding: utf-8

module Mom
  class Definition
    class Attribute

      class OptionBuilder
        include Concord.new(:name, :options, :default_options)
        include Procto.call

        def call
          default_options.merge(local_options).merge!(options)
        end

        private

        def local_options
          {entity: name, prefix: name_prefix}
        end

        def name_prefix
          name
        end
      end # OptionBuilder

      class Entity < self

        attr_reader :block

        def self.build(name, options, default_options, block)
          new(name, self::OptionBuilder.call(name, options, default_options), block)
        end

        def initialize(name, options, block)
          super(name, options)
          @anonymous  = !!block
          @definition = Definition.build(entity_name, options, &block) if anonymous?
        end

        def definition(environment)
          anonymous? ? @definition : environment.definition(entity_name)
        end

        def anonymous?
          @anonymous
        end

        def entity_name
          options.fetch(:entity, referenced_name)
        end

        private

        def referenced_name
          name
        end

        def builder
          Morpher::Builder::Attribute::Entity
        end
      end # Entity

      class Collection < Entity
        class OptionBuilder < Attribute::OptionBuilder
          private

          def name_prefix
            Mom.singularize(super)
          end
        end

        private

        def referenced_name
          Mom.singularize(super)
        end

        def builder
          Morpher::Builder::Attribute::Collection
        end
      end # Collection

    end # Attribute
  end # Definition
end # Mom
