# encoding: utf-8

module Mom
  class Definition

    class Attribute

      include AbstractType
      include Concord::Public.new(:name, :options)

      abstract_method :builder

      def initialize(name, options)
        super(name.to_sym, options)
      end

      def node(environment, definition_builder)
        builder.call(self, environment, definition_builder)
      end

      def default_value?
        primitive? && !default_value.equal?(Undefined)
      end

      def old_key
        case options[:key_transform]
        when :neutral
          fetch_old_key(name)
        when :symbolize
          fetch_old_key(name).to_s
        else
          fetch_old_key(name)
        end
      end

      def new_key
        case options[:key_transform]
        when :neutral
          name
        when :symbolize
          name.to_sym
        else
          name
        end
      end

      def primitive?
        false
      end

      private

      def fetch_old_key(name)
        options.fetch(:from, name)
      end

    end # Attribute
  end # Definition
end # Mom
