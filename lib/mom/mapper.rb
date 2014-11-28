# encoding: utf-8

module Mom

  class Environment

    def mappers(models)
      registry { |definition|
        Mapper.build(definition, self, models)
      }
    end

    def mapper(name, models)
      Mapper.build(definitions[name], self, models)
    end
  end # Environment

  class Mapper

    def self.build(definition, environment, models)
      new(Morpher.transformer(
        name:        :object,
        definition:  definition,
        environment: environment,
        models:      models
      ))
    end

    attr_reader :loader
    attr_reader :dumper

    def initialize(evaluator)
      @loader = evaluator
      @dumper = evaluator.inverse
    end

    def load(tuple)
      loader.call(tuple)
    end

    def dump(object)
      dumper.call(object)
    end
  end # Mapper
end # Mom
