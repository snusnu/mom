# encoding: utf-8

module Mom
  module Entity

    def self.build(definition, builder_name)
      Builder[builder_name].call(definition)
    end

    class Builder

      REGISTRY = {}

      def self.register(name, builder)
        REGISTRY[name] = builder
      end

      def self.[](name)
        REGISTRY.fetch(name)
      end

      def self.registered?(name)
        REGISTRY.key?(name)
      end

    end # Builder
  end # Entity
end # Mom
