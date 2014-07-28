
module Mom
  extend ::Morpher::NodeHelpers

  PROCESSORS = {

    Noop:             ->(_) { s(:input) },

    ParsedInt10:      ->(_) { s(:parse_int, 10) },
    ParsedInt10Array: ->(_) { s(:map, s(:parse_int, 10)) },

    String:           ->(_) { s(:guard, s(:primitive, String)) },
    Integer:          ->(_) { s(:guard, s(:is_a,      Integer)) },
    Date:             ->(_) { s(:guard, s(:primitive, Date)) },
    DateTime:         ->(_) { s(:guard, s(:primitive, DateTime)) },
    Boolean:          ->(_) { s(:guard, s(:or, s(:primitive, TrueClass), s(:primitive, FalseClass))) },

    OString:          ->(_) { s(:guard, s(:or, s(:primitive, String),   s(:primitive, NilClass))) },
    OInteger:         ->(_) { s(:guard, s(:or, s(:is_a,      Integer),  s(:primitive, NilClass))) },
    ODate:            ->(_) { s(:guard, s(:or, s(:primitive, Date),     s(:primitive, NilClass))) },
    ODateTime:        ->(_) { s(:guard, s(:or, s(:primitive, DateTime), s(:primitive, NilClass))) },

    IntArray:         ->(_) { s(:map, s(:guard, s(:is_a,      Integer))) },
    StringArray:      ->(_) { s(:map, s(:guard, s(:primitive, String))) },

    OIntArray: ->(_) {
      s(:block,
        s(:guard,
          s(:or,
            s(:primitive, NilClass),
            s(:primitive, Array))),
        s(:map, s(:guard, s(:is_a, Integer))))
    },

    OStringArray: ->(_) {
      s(:block,
        s(:guard,
          s(:or,
            s(:primitive, NilClass),
            s(:primitive, Array))),
        s(:map, s(:guard, s(:primitive, String))))
    }

  }.freeze
end # Mom
