# encoding: utf-8

module Mom
  class Environment

    include Anima.new(
      :definitions,
      :processors,
      :models
    )

    include Lupo.enumerable(:definitions)

    DEFAULTS = {
      processors: PROCESSORS
    }.freeze

    BUILD_OPTIONS = Definition::DEFAULT_OPTIONS.merge(DEFAULTS).freeze

    def self.build(model_builder = :anima, options = BUILD_OPTIONS, &block)
      default_options = options.reject { |k,_| k == :processors }
      definitions     = Definition::Registry.build(default_options, &block)
      new(
        definitions: definitions,
        processors:  options.fetch(:processors),
        models:      definitions.models(model_builder)
      )
    end

    def self.new(attributes)
      super(DEFAULTS.merge(attributes))
    end

    def hash_transformers
      registry { |definition, env| Morpher.hash_transformer(definition, env) }
    end

    def object_mappers
      registry { |definition, env| Morpher.object_mapper(definition, env) }
    end

    def hash_transformer(name = EMPTY_STRING, options = {prefix: name}, &block)
      Morpher.transformer(:hash, definition(name, options, &block), self)
    end

    def object_mapper(name = EMPTY_STRING, options = {prefix: name}, &block)
      Morpher.transformer(:object, definition(name, options, &block), self)
    end

    def processor(name, options)
      processors.fetch(name).call(options)
    end

    def model(name)
      models[name]
    end

    def model_processor(definition)
      models.processor(definition)
    end

    def default_options
      definitions.default_options
    end

    private

    def definition(entity_name, options, &block)
      definitions.definition(entity_name, options, &block)
    end

    def registry
      Registry.new(each_with_object({}) { |(name, definition), h|
        h[name] = yield(definition, self)
      })
    end

  end # Environment
end # Mom
