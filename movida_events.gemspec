# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movida_events/version'

Gem::Specification.new do |spec|
  spec.name = 'movida_events'
  spec.version = MovidaEvents::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']
  spec.license = 'MIT'

  spec.summary = 'A BeBanjo Movida event stream processor'
  spec.homepage = 'https://github.com/nullscreen/movida_events'

  rubydoc = 'https://www.rubydoc.info/gems'
  spec.metadata = {
    'changelog_uri' => "#{spec.homepage}/blob/main/CHANGELOG.md",
    'documentation_uri' => "#{rubydoc}/#{spec.name}/#{spec.version}",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir['lib/**/*.rb', '*.md', '*.txt', '.yardopts']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'activesupport', '>= 4.2'
  spec.add_dependency 'almodovar', '>= 1.5', '< 3'

  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
