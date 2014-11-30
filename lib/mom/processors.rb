
module Mom
  extend ::Morpher::NodeHelpers

  PROCESSORS = {

    Noop:                  ->(_) { s(:input) },

    PInt10:                ->(_) { s(:parse_int, 10) },
    PInt10Array:           ->(_) { s(:map, s(:parse_int, 10)) },
    PIso8601DateTime:      ->(_) { s(:parse_iso8601_date_time, 0) },

    String:                ->(_) { type(:primitive, String) },
    Integer:               ->(_) { type(:is_a,      Integer) },
    Date:                  ->(_) { type(:primitive, Date) },
    DateTime:              ->(_) { type(:primitive, DateTime) },
    Boolean:               ->(_) { s(:guard, s(:boolean)) },

    OString:               ->(_) { optional_type(:primitive, String) },
    OInteger:              ->(_) { optional_type(:is_a,      Integer) },
    ODate:                 ->(_) { optional_type(:primitive, Date) },
    ODateTime:             ->(_) { optional_type(:primitive, DateTime) },

    IntArray:              ->(_) { array_type(:is_a,      Integer) },
    StringArray:           ->(_) { array_type(:primitive, String) },

    OIntArray:             ->(_) { optional_array_type(:is_a, Integer) },
    OStringArray:          ->(_) { optional_array_type(:primitive, String) },

  }.freeze

  def self.type(matcher, type)
    s(:guard, s(matcher, type))
  end

  def self.optional_type(matcher, type)
    s(:guard, s(:xor, s(matcher, type), s(:primitive, NilClass)))
  end

  def self.array_type(matcher, type)
    s(:map, type(matcher, type))
  end

  def self.optional_array_type(matcher, type)
    s(:block, optional_type(:primitive, Array), array_type(matcher, type))
  end
end # Mom
