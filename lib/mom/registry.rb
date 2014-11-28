# encoding: utf-8

module Mom

  class Registry
    include Lupo.collection(:items)

    def [](name)
      items.fetch(name)
    end

    def fetch(name, &block)
      items.fetch(name, &block)
    end
  end # Registry
end # Mom
