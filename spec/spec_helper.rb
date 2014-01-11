# encoding: utf-8

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

# Connect code quality with test coverage

unless ENV['TRAVIS']
  require 'simplecov'
  require 'simplecov-rcov'

  if ENV['CIRCLE_ARTIFACTS']
    require 'simplecov'
    dir = File.join("..", "..", "..", ENV['CIRCLE_ARTIFACTS'], "coverage")
    SimpleCov.coverage_dir(dir)
  end

  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start do
    add_filter 'spec'
    add_filter 'vendor'
    add_filter 'features'
  end
end

require 'orchestrate.io'
require 'rspec'
require 'webmock/rspec'
require 'json'
require 'timecop'

# Use Webmock to route all requests to our Sinatra application `PseudoOrchestrateIo`.
require_relative 'support/pseudo_orchestrate.io'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Stub any HTTP requests to `api.orchestrate.io` with WebMock
  # and returns prepended content.
  config.before(:each) do
    stub_request(:any, /api.orchestrate.io/).to_rack(PseudoOrchestrateIo.new)
  end
end

def load_json(string)
  JSON.parse(string)
end

def dump_json(object)
  JSON.pretty_generate(object)
end
