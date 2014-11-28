# encoding: utf-8

module Mom
  class Environment
    include Concord.new(:definitions, :processors)

    BUILD_OPTIONS = Definition::DEFAULT_OPTIONS.merge(
      processors: PROCESSORS
    ).freeze

    def self.build(options = EMPTY_HASH, &block)
      opts       = BUILD_OPTIONS.merge(options)
      processors = opts.delete(:processors) { |_| PROCESSORS }

      new(DSL::Schema.call(opts, &block), processors)
    end

    def self.coerce(schema, processors = PROCESSORS)
      new(schema.definitions, processors)
    end

    def self.new(definitions, processors)
      super(Registry.new(definitions), processors)
    end

    def hash_transformers
      registry { |definition|
        Morpher.transformer(
          name:        :hash,
          definition:  definition,
          environment: self
        )
      }
    end

    def object_mappers(entities)
      registry { |definition|
        Morpher.transformer(
          name:        :object,
          definition:  definition,
          environment: self,
          entities:    entities
        )
      }
    end

    def entities(builder_name)
      registry { |definition| Entity.build(definition, builder_name) }
    end

    def processor(name, options)
      processors.fetch(name).call(options)
    end

    def definition(entity_name)
      definitions[entity_name]
    end

    private

    def registry
      Registry.new(definitions.each_with_object({}) { |(name, definition), h|
        h[name] = yield(definition)
      })
    end
  end # Environment
end # Mom
