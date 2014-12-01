# encoding: utf-8

module Mom

  class Environment

    def mappers(entities)
      registry { |definition|
        Mapper.build(definition, self, entities)
      }
    end

    def mapper(name, entities)
      Mapper.build(definitions[name], self, entities)
    end
  end # Environment

  class Mapper

    def self.build(definition, environment, entities)
      new(Morpher::Builder::Object.call(
        definition:  definition,
        environment: environment,
        entities:    entities
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
