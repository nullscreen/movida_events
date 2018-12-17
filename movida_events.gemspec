# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movida_events/version'

Gem::Specification.new do |spec|
  spec.name = 'movida_events'
  spec.version = MovidaEvents::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']
  spec.license = 'Apache-2.0'

  spec.summary = 'A BeBanjo Movida event stream processor'
  spec.homepage = 'https://github.com/machinima/movida_events'

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.2', '< 6'
  spec.add_dependency 'almodovar', '~> 1.5'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redcarpet', '~> 3.4'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 0.61'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'yard', '~> 0.9.11'
end
