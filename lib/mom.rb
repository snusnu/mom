# encoding: utf-8

require 'forwardable'

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

  def self.environment(options = EMPTY_HASH, &block)
    Environment.coerce(schema(options).call(&block))
  end

  def self.schema(options = EMPTY_HASH, definitions = {})
    DSL::Schema.new(options, definitions)
  end

  def self.singularize(word)
    Inflecto.singularize(word.to_s).to_sym
  end
end # Mom

require 'mom/version'
require 'mom/registry'
require 'mom/constraint'
require 'mom/definition'
require 'mom/definition/attribute'
require 'mom/definition/attribute/primitive'
require 'mom/definition/attribute/embedded'
require 'mom/dsl'
require 'mom/morpher/builder/attribute'
require 'mom/morpher/builder/attribute/primitive'
require 'mom/morpher/builder/attribute/embedded'
require 'mom/morpher/builder'
require 'mom/morpher'
require 'mom/entity/builder'
require 'mom/entity/builder/anima'
require 'mom/environment'
