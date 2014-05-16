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
