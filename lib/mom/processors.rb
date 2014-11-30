
module Mom
  extend ::Morpher::NodeHelpers

  PROCESSORS = {

    Noop:         ->(_) { s(:input) },

    PInt10:       ->(_) { parsed_type(:parse_int, :is_a, Integer, 10) },
    PInt10Array:  ->(_) { parsed_array_type(:parse_int, :is_a, Integer, 10) },
    PDateTime:    ->(_) { parsed_type(:parse_iso8601_date_time, :primitive, DateTime, 0) },

    String:       ->(_) { type(:primitive, String) },
    Integer:      ->(_) { type(:is_a,      Integer) },
    Date:         ->(_) { type(:primitive, Date) },
    DateTime:     ->(_) { type(:primitive, DateTime) },
    Boolean:      ->(_) { s(:guard, s(:boolean)) },

    OString:      ->(_) { optional_type(:primitive, String) },
    OInteger:     ->(_) { optional_type(:is_a,      Integer) },
    ODate:        ->(_) { optional_type(:primitive, Date) },
    ODateTime:    ->(_) { optional_type(:primitive, DateTime) },

    IntArray:     ->(_) { array_type(:is_a,      Integer) },
    StringArray:  ->(_) { array_type(:primitive, String) },

    OIntArray:    ->(_) { optional_array_type(:is_a, Integer) },
    OStringArray: ->(_) { optional_array_type(:primitive, String) },

  }.freeze

  def self.type(matcher, type)
    s(:guard, s(matcher, type))
  end

  def self.optional_type(matcher, type)
    s(:guard, s(:xor, s(matcher, type), s(:primitive, NilClass)))
  end

  def self.parsed_type(parser, matcher, target, *options)
    s(:block, s(parser, *options), type(matcher, target))
  end

  def self.array_type(matcher, type)
    s(:map, type(matcher, type))
  end

  def self.optional_array_type(matcher, type)
    s(:block, optional_type(:primitive, Array), array_type(matcher, type))
  end

  def self.parsed_array_type(parser, matcher, target, *options)
    s(:map, parsed_type(parser, matcher, target, *options))
  end
end # Mom
