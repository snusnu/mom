# -*- encoding: utf-8 -*-

require File.expand_path('../lib/mom/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "mom"
  gem.version     = Mom::VERSION.dup
  gem.authors     = [ "Martin Gamsjaeger (snusnu)" ]
  gem.email       = [ "gamsnjaga@gmail.com" ]
  gem.description = "Morphing (object) Mapper"
  gem.summary     = "Map structured data to objects and back"
  gem.homepage    = "https://github.com/snusnu/mom"

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO.md]
  gem.license          = 'MIT'

  gem.add_dependency 'concord',             '~> 0.1.5'
  gem.add_dependency 'anima',               '~> 0.2.0'
  gem.add_dependency 'lupo',                '~> 0.0.1'
  gem.add_dependency 'procto',              '~> 0.0.2'
  gem.add_dependency 'morpher',             '~> 0.2.3'
  gem.add_dependency 'adamantium',          '~> 0.2.0'
  gem.add_dependency 'abstract_type',       '~> 0.0.7'
  gem.add_dependency 'inflecto',            '~> 0.0.2'

  gem.add_development_dependency 'bundler', '~> 1.6', '>= 1.6.1'
end
