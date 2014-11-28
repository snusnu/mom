# encoding: utf-8

module Mom
  module Model

    def self.build(definition, builder_name)
      Builder[builder_name].call(definition)
    end

    class Builder

      REGISTRY = {}

      def self.[](name)
        REGISTRY.fetch(name)
      end

      def self.registered?(name)
        REGISTRY.key?(name)
      end

      def self.register(name)
        REGISTRY[name] = new
      end
      private_class_method :register

    end # Builder
  end # Model
end # Mom
