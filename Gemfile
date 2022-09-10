# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

not_jruby = %i[ruby mingw x64_mingw].freeze

gem 'byebug', platforms: not_jruby
# Fix mini_portile2 install for the old versions of nokogiri
# required by almodovar 1.7.7
gem 'net-ftp'
gem 'redcarpet', '~> 3.5', platforms: not_jruby
gem 'yard', '~> 0.9.25', platforms: not_jruby

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.6')
  gem 'rubocop', '~> 1.32.0'
  gem 'rubocop-rspec', '~> 2.12'
  gem 'simplecov', '>= 0.17.1'
  gem 'simplecov-cobertura', '~> 2.1'
end
