# encoding: utf-8

require 'concord'
require 'anima'
require 'morpher'
require 'lupo'
require 'procto'
require 'adamantium'
require 'abstract_type'
require 'inflecto'

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

  def self.entity_registry(definitions, processors, model_builder = :anima)
    Entity.registry(environment(definitions, processors, model_builder))
  end

  def self.hash_dressers(definitions, processors, model_builder = :anima)
    each_definition(definitions, processors, model_builder) { |definition, env|
      Morpher.hash_dresser(definition, env)
    }
  end

  def self.object_mappers(definitions, processors, model_builder = :anima)
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
require 'mom/morpher/builder/entity'
require 'mom/morpher'
require 'mom/morpher/registry'
require 'mom/model/registry'
require 'mom/model/builder'
require 'mom/model/builder/anima'
require 'mom/mapper'
require 'mom/environment'
require 'mom/registry'
require 'mom/entity'
