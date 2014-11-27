# encoding: utf-8

module Mom

  def self.mappers(definitions, processors = PROCESSORS, model_builder = :anima)
    environment(definitions, processors, model_builder).mappers
  end

  class Environment

    def mappers
      registry { |definition, env| Mapper.build(definition, env) }
    end

    def mapper(name)
      Mapper.build(definitions[name], self)
    end

  end # Environment

  class Mapper

    def self.build(definition, environment)
      new(Morpher.object_mapper(definition, environment))
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
