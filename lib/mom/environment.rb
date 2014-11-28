# encoding: utf-8

module Mom
  class Environment
    include Concord.new(:definitions, :processors)

    BUILD_OPTIONS = Definition::DEFAULT_OPTIONS.merge(
      processors: PROCESSORS
    ).freeze

    def self.build(options = BUILD_OPTIONS, &block)
      opts = options.reject { |k,_| k == :processors }
      dsl  = DSL::Environment.new(BUILD_OPTIONS.merge(opts), {})
      dsl.instance_eval(&block) if block

      new(Registry.new(dsl.definitions), options.fetch(:processors, PROCESSORS))
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
