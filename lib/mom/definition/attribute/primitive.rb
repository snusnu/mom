# encoding: utf-8

module Mom
  class Definition
    class Attribute

      class Primitive < self

        class OptionBuilder

          HANDLERS        = {}
          NOOP_CONSTRAINT = { constraint: :Noop }

          def self.handle(&test)
            HANDLERS[self] = test
          end

          class Unconstrained < self
            handle { |args| args.size == 0 }

            private

            def options
              NOOP_CONSTRAINT
            end

            class Configured < self
              handle { |args| args.size == 1 && args.first.is_a?(Hash) }

              private

              def options
                args.first.merge(super)
              end
            end # Configured
          end # Unconstrained

          class Constrained < self
            handle { |args| args.size == 1 && args.first.is_a?(Symbol) }

            private

            def options
              { constraint: args.first }
            end

            class Configured < self
              handle { |args| args.size == 2 && args.last.is_a?(Hash) }

              private

              def options
                args.last.merge(super)
              end
            end # Configured
          end # Constrained

          include Concord.new(:name, :default_options, :args)

          def self.call(name, default_options, args)
            handler = HANDLERS.select { |_, test| test.call(args) }.keys.first
            raise ArgumentError.new("Invalid options: #{args}") unless handler
            handler.new(name, default_options, args).call
          end

          def initialize(name, default_options, args)
            super

            @name_generator = default_options.fetch(:name_generator)
            @name_prefix    = default_options.fetch(:prefix)
          end

          def call
            default_options.
              reject { |k,_| k == :name_generator }.
              merge!(from: from).
              merge!(default: Undefined).
              merge!(options)
          end

          private

          def from
            @name_generator.call(@name_prefix, name)
          end
        end # OptionBuilder

        def self.build(name, default_options, args)
          new(name, OptionBuilder.call(name, default_options, args))
        end

        attr_reader :constraint
        attr_reader :default_value

        def initialize(name, options)
          super

          @constraint    = options.fetch(:constraint)
          @default_value = options.fetch(:default)
        end

        def primitive?
          true
        end
      end # Primitive
    end # Attribute
  end # Definition
end # Mom
