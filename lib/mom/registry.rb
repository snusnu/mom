# encoding: utf-8

module Mom

  class Registry
    extend Forwardable
    include Lupo.collection(:items)

    def_delegators :@items, :[], :fetch, :keys, :values
  end # Registry
end # Mom
