# encoding: utf-8

module Mom

  module Constraint

    BUILTIN = ->(_) {
      use Constraint.empty

      add(:String)       { |opts| check(:primitive, String) }
      add(:Integer)      { |opts| check(:is_a,      Integer) }
      add(:Date)         { |opts| check(:primitive, Date) }
      add(:DateTime)     { |opts| check(:primitive, DateTime) }
      add(:Boolean)      { |opts| s(:guard, s(:boolean)) }

      add(:OString)      { |opts| maybe(:primitive, String) }
      add(:OInteger)     { |opts| maybe(:is_a,      Integer) }
      add(:ODate)        { |opts| maybe(:primitive, Date) }
      add(:ODateTime)    { |opts| maybe(:primitive, DateTime) }

      add(:IntegerArray) { |opts| array(:is_a,      Integer) }
      add(:StringArray)  { |opts| array(:primitive, String) }

      add(:PInteger) { |opts|
        parse(:parse_int, opts.fetch(:base, 10))
      }

      add(:PDateTime) { |opts|
        parse(:parse_iso8601_date_time, opts.fetch(:fractional, 0))
      }

      add(:PIntegerArray) { |opts|
        parse_array(:parse_int, opts.fetch(:base, 10))
      }

      add(:EqualValue) { |opts|
        s(:guard,
          s(:and, *opts.fetch(:names).combination(2).map { |left, right|
            s(:eql, s(:key_fetch, left), s(:key_fetch, right))
          }))
      }
    }

    def self.empty
      DSL::Constraint.call { add(:Noop) { s(:input) } }
    end

    def self.builtin
      DSL::Constraint.call(&BUILTIN)
    end

    def self.build(&block)
      ->(options) { Context.new(options).call(&block) }
    end

    class Context
      include Concord.new(:options)
      include ::Morpher::NodeHelpers

      def call(&block)
        instance_exec(options, &block)
      end

      private

      def check(matcher, type)
        s(:guard, s(matcher, type))
      end

      def maybe(matcher, type)
        s(:guard, s(:xor, s(:primitive, NilClass), s(matcher, type)))
      end

      def array(matcher, type)
        s(:map, check(matcher, type))
      end

      def parse(parser, *options)
        s(parser, *options)
      end

      def parse_array(parser, *options)
        s(:map, parse(parser, *options))
      end

      def enum(*values)
        s(:guard, s(:or, *values.map { |v| s(:eql, s(:input), s(:static, v)) }))
      end
    end # Context
  end # Constraint
end # Mom
