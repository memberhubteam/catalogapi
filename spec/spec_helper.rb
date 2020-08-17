# frozen_string_literal: true

require 'bundler/setup'
require 'catalogapi'
require 'webmock/rspec'

CatalogAPI.key = 'test-key'
CatalogAPI.username = 'username'

def fixture(path, opts = { json: true })
  body = File.read("#{Dir.pwd}/spec/fixtures/#{path}")
  return body unless opts[:json]

  JSON.parse(body, symbolize_names: true)
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
