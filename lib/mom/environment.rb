# encoding: utf-8

module Mom
  class Environment
    include Concord.new(:definitions, :processors)

    BUILD_OPTIONS = Definition::DEFAULT_OPTIONS.merge(
      processors: PROCESSORS
    ).freeze

    def self.build(options = BUILD_OPTIONS, &block)
      opts       = BUILD_OPTIONS.merge(options)
      processors = opts.delete(:processors) { |_| PROCESSORS }

      new(Registry.new(DSL::Environment.call(opts, &block)), processors)
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

    def object_mappers(models)
      registry { |definition|
        Morpher.transformer(
          name:        :object,
          definition:  definition,
          environment: self,
          models:      models
        )
      }
    end

    def models(builder_name)
      registry { |definition| Model.build(definition, builder_name) }
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
