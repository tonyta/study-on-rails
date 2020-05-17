require "rails_helper"
require "capybara/rspec"

Capybara.default_driver = :selenium
Capybara.app_host = "http://www.example.com"

require "rack_session_access/capybara"

module SystemAuthHelpers
  attr_reader :signed_in_user

  def sign_in(user)
    user = User.find_or_create_by!(username: user) if user.is_a?(String)
    page.set_rack_session(user_id: user.id)
    @signed_in_user = user
  end

  def sign_out
    reset_session!
    @signed_in_user = nil
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL,           system: true
  config.include Capybara::RSpecMatchers, system: true
  config.include SystemAuthHelpers, type: :system
end
