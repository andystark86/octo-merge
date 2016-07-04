$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'rspec/its'
require 'webmock/rspec'

require_relative 'support/simple_git'
require_relative 'support/setup_example_repos'
require_relative 'support/webmock_stubs'

require 'octo_merge'

Git.verbose!(ENV["VERBOSE"] || false)

RSpec.configure do |config|
  config.order = 'random'
end
