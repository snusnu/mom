# encoding: utf-8

module Mom

  class Registry
    include Lupo.collection(:items)

    def [](name)
      items.fetch(name)
    end
  end # Registry
end # Mom
