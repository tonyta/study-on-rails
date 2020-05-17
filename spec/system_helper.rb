require "rails_helper"
require "capybara/rspec"

Capybara.default_driver = :selenium

RSpec.configure do |config|
  config.include Capybara::DSL,           system: true
  config.include Capybara::RSpecMatchers, system: true
end
