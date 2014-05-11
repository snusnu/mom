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
  Undefined = Class.new.freeze

  # An empty hash useful for (default} parameters
  EMPTY_HASH = {}.freeze

  # An empty frozen string
  EMPTY_STRING = ''.freeze

  # An empty frozen array
  EMPTY_ARRAY = [].freeze

end # Mom

require 'mom/version'

require 'mom/entity'
require 'mom/entity/definition'
require 'mom/entity/definition/registry'
require 'mom/entity/definition/attribute'
require 'mom/entity/definition/attribute/primitive'
require 'mom/entity/definition/attribute/embedded'
require 'mom/entity/morpher/builder/attribute'
require 'mom/entity/morpher/builder/attribute/primitive'
require 'mom/entity/morpher/builder/attribute/embedded'
require 'mom/entity/morpher/builder/entity'
require 'mom/entity/morpher'
require 'mom/entity/morpher/registry'
require 'mom/entity/model/registry'
require 'mom/entity/model/builder'
require 'mom/entity/model/builder/anima'
require 'mom/entity/mapper'
require 'mom/entity/environment'
require 'mom/entity/registry'
