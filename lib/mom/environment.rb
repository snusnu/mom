# encoding: utf-8

module Mom
  class Environment
    include Concord.new(:definitions, :constraints)

    def self.coerce(schema)
      new(schema.definitions, schema.constraints)
    end

    def self.new(definitions, constraints)
      super(Registry.new(definitions), constraints)
    end

    def hash_transformers
      registry { |definition|
        Morpher::Builder::Hash.executor(
          :definition  => definition,
          :environment => self
        )
      }
    end

    def object_mappers(entities)
      registry { |definition|
        Morpher::Builder::Object.executor(
          :definition  => definition,
          :environment => self,
          :entities    => entities
        )
      }
    end

    def entities(builder_name)
      registry { |definition| Entity.build(definition, builder_name) }
    end

    def constraint(name, options)
      constraints.fetch(name).call(options)
    end

    def definition(entity_name)
      definitions[entity_name]
    end

    private

    def registry
      Registry.new(definitions.each_with_object({}) { |(name, definition), h|
        h[name] = yield(definition)
      })
    end
  end # Environment
end # Mom
