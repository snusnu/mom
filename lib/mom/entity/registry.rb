# encoding: utf-8

module Mom
  class Entity

    class Registry
      include Concord.new(:entries)

      def [](name)
        entries.fetch(name)
      end
    end # Registry
  end # Entity
end # Mom
