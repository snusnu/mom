# encoding: utf-8

module Mom

  class Registry
    include Concord.new(:entries)

    BUILD_OPTIONS = Environment::BUILD_OPTIONS

    def self.build(model_builder = :anima, options = BUILD_OPTIONS, &block)
      Entity.registry(Environment.build(model_builder, options, &block))
    end

    def [](name)
      entries.fetch(name)
    end
  end # Registry
end # Mom
