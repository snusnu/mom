# encoding: utf-8

module Mom
  module Model
    class Builder

      class Anima < self

        register :anima

        def call(definition)
          Class.new do
            include ::Anima.new(*definition.attribute_names)

            define_singleton_method :name do
              "Entity(#{definition.entity_name})"
            end
          end
        end
      end # Anima
    end # Builder
  end # Model
end # Mom
