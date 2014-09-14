ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
require "minitest/rails/capybara"
require "mocha/setup"
# Uncomment for awesome colorful output
require "minitest/pride"
require 'minitest/colorize'

class MiniTest::Spec
  class << self
    alias :context :describe
  end
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  class << self
    alias :context :describe
  end
end

require "mocha/setup"
