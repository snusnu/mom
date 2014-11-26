# encoding: utf-8

require 'concord'
require 'anima'
require 'morpher'
require 'lupo'
require 'procto'
require 'adamantium'
require 'abstract_type'
require 'inflecto'

require 'mom/processors'

# Morpher object mapper
module Mom

  # Represent an undefined argument
  Undefined = Module.new.freeze

  # An empty hash useful for (default} parameters
  EMPTY_HASH = {}.freeze

  # An empty frozen string
  EMPTY_STRING = ''.freeze

  # An empty frozen array
  EMPTY_ARRAY = [].freeze

  def self.singularize(word)
    Inflecto.singularize(word.to_s).to_sym
  end

  def self.definition_registry(options = Definition::Registry::DEFAULT_OPTIONS, definitions = EMPTY_HASH, &block)
    Definition::Registry.build(options, definitions, &block)
  end

  def self.entity_registry(definitions, processors = PROCESSORS, model_builder = :anima)
    Entity.registry(environment(definitions, processors, model_builder))
  end

  def self.hash_transformers(definitions, processors = PROCESSORS, model_builder = :anima)
    each_definition(definitions, processors, model_builder) { |definition, env|
      Morpher.hash_transformer(definition, env)
    }
  end

  def self.object_mappers(definitions, processors = PROCESSORS, model_builder = :anima)
    each_definition(definitions, processors, model_builder) { |definition, env|
      Morpher.object_mapper(definition, env)
    }
  end

  def self.environment(definitions, processors, model_builder = :anima)
    definitions.environment(definitions.models(model_builder), processors)
  end

  def self.each_definition(definitions, processors, model_builder)
    env = environment(definitions, processors, model_builder)
    env.each_with_object({}) { |(name, definition), hash|
      hash[name] = yield(definition, env)
    }
  end
  private_class_method :each_definition

end # Mom

require 'mom/version'
require 'mom/definition'
require 'mom/definition/registry'
require 'mom/definition/attribute'
require 'mom/definition/attribute/primitive'
require 'mom/definition/attribute/embedded'
require 'mom/morpher/builder/attribute'
require 'mom/morpher/builder/attribute/primitive'
require 'mom/morpher/builder/attribute/embedded'
require 'mom/morpher/builder'
require 'mom/morpher'
require 'mom/model/registry'
require 'mom/model/builder'
require 'mom/model/builder/anima'
require 'mom/mapper'
require 'mom/environment'
require 'mom/registry'
require 'mom/entity'
