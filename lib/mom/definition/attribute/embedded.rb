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
          @block       = block
        end

        def embed?
          !!block
        end

        def entity_name
          embed? ? options.fetch(:entity, name) : referenced_name
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
            Inflecto.singularize(super.to_s).to_sym
          end
        end

        private

        def referenced_name
          Inflecto.singularize(name.to_s).to_sym
        end

        def builder
          Morpher::Builder::Attribute::Collection
        end
      end # Collection

    end # Attribute
  end # Definition
end # Mom