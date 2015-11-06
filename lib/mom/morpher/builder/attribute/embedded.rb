# encoding: utf-8

module Mom
  class Morpher
    class Builder
      class Attribute
        class Entity < self
          register Definition::Attribute::Entity

          def self.new(attribute, *args)
            if self < Entity
              super
            elsif attribute.collection?
              Collection.new(attribute, *args)
            else
              super
            end
          end

          class Collection < self

            def self.new(attribute, *args)
              return super if self < Collection

              cardinality = attribute.cardinality

              if cardinality.is_a?(Integer) && cardinality < Float::INFINITY
                Fixed
              elsif cardinality.respond_to?(:cover?)
                Range
              else
                Unbound
              end.new(attribute, *args)
            end

            def initialize(*)
              super
              @cardinality = attribute.cardinality
            end

            Unbound = Class.new(self)

            class Fixed < self
              private

              def node
                s(:block, super, s(:guard, predicate))
              end

              def predicate
                s(:eql, s(:attribute, :size), s(:static, cardinality))
              end
            end # Fixed

            class Range < Fixed
              def initialize(*)
                super

                @min = cardinality.min
                @max = cardinality.max
              end

              private

              def predicate
                s(:and, comparison(:gte, @min), comparison(ltop, @max))
              end

              def comparison(kind, value)
                s(kind, s(:attribute, :size), s(:static, value))
              end

              def ltop
                cardinality.exclude_end? ? :lt : :lte
              end
            end # Range

            private

            attr_reader :cardinality

            def node
              s(:map, super)
            end
          end # Collection

          def initialize(attribute, *args)
            super
            @definition = attribute.definition(environment)
          end

          private

          def node
            builder.with(:definition => @definition).call
          end
        end # Entity
      end # Attribute
    end # Builder
  end # Morpher
end # Mom
