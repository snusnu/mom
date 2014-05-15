# encoding: utf-8

module Mom
  class Definition
    class Attribute

      class Primitive < self

        class OptionBuilder

          class InvalidOptions < StandardError
            include Concord.new(:options)

            def message
              "options not recognized: #{options.inspect}"
            end
          end # InvalidOptions

          class InternalError < StandardError
            include Concord.new(:source, :options)

            def message
              "BUG in #{source.class.name}: #{options.inspect}"
            end
          end # InternalError

          include Concord.new(:name, :default_options, :args)
          include Procto.call

          NULL_PROCESSOR = { processor: :Noop }

          def initialize(name, default_options, args)
            super

            @name_generator       = default_options.fetch(:name_generator)
            @name_prefix          = default_options.fetch(:prefix)
            @default_primitive    = default_primitive?
            @configured_primitive = configured_primitive?
            @referenced_processor = referenced_processor?
            @configured_processor = configured_processor?

            @primitive = primitive?
            @processed = processed?

            assert_valid_options
          end

          def call
            @default_options.
              reject { |k,_| k == :name_generator }.
              merge!(from: from_name).
              merge!(default: Undefined).
              merge!(options)
          end

          private

          def assert_valid_options
            raise InvalidOptions.new(args) unless valid?
          end

          def valid?
            @primitive || @processed
          end

          def primitive?
            @default_primitive || @configured_primitive
          end

          def processed?
            @referenced_processor || @configured_processor
          end

          def default_primitive?
            args.length == 0
          end

          def configured_primitive?
            args.length == 1 && args.first.is_a?(Hash)
          end

          def referenced_processor?
            args.length == 1 && args.first.is_a?(Symbol)
          end

          def configured_processor?
            args.length == 2 && args.first.is_a?(Symbol) && args.last.is_a?(Hash)
          end

          def from_name
            @name_generator.call(@name_prefix, name)
          end

          def options
            if @default_primitive
              NULL_PROCESSOR
            elsif @configured_primitive
              args.first.merge(NULL_PROCESSOR)
            elsif @referenced_processor
              { processor: args.first }
            elsif @configured_processor
              args.last.merge(processor: args.first)
            else
              raise InternalError.new(self, args)
            end
          end
        end # OptionBuilder

        def self.build(name, default_options, args)
          new(name, OptionBuilder.call(name, default_options, args))
        end

        attr_reader :processor
        attr_reader :default_value

        def initialize(name, options)
          super

          @processor     = options.fetch(:processor)
          @default_value = options.fetch(:default)
        end

        def primitive?
          true
        end

        private

        def builder
          Morpher::Builder::Attribute::Primitive
        end
      end # Primitive
    end # Attribute
  end # Definition
end # Mom