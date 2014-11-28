# encoding: utf-8

module Mom
  module Entity
    class Builder

      register :anima, ->(definition) {
        Class.new do
          include Anima.new(*definition.attribute_names)

          define_singleton_method :name do
            "Entity(#{definition.entity_name})"
          end
        end
      }

    end # Builder
  end # Entity
end # Mom
