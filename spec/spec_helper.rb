# frozen_string_literal: true

require 'byebug' if Gem.loaded_specs['byebug']
require 'webmock/rspec'

if Gem.loaded_specs['simplecov'] && (ENV.fetch('COVERAGE', nil) || ENV.fetch('CI', nil))
  require 'simplecov'
  if ENV['CI']
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end

  SimpleCov.start do
    enable_coverage :branch
    add_filter '/spec/'
    add_filter '/vendor/'
  end
end

require 'movida_events'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
end
